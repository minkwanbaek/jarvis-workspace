#!/usr/bin/env bash
set -euo pipefail

STATE_DIR="$HOME/.openclaw/runtime"
STATE_FILE="$STATE_DIR/gateway-watchdog.json"
mkdir -p "$STATE_DIR"

UNIT="openclaw-gateway.service"
PORT="18789"
THRESHOLD_SEC=1800
NOW=$(date +%s)

is_healthy() {
  if ! systemctl --user is-active --quiet "$UNIT"; then
    return 1
  fi
  python3 - <<'PY'
import socket, sys
s=socket.socket()
s.settimeout(2)
try:
    s.connect(("127.0.0.1", 18789))
    print("ok")
except Exception:
    sys.exit(1)
finally:
    try: s.close()
    except: pass
PY
}

read_state() {
  python3 - "$STATE_FILE" <<'PY'
import json, sys, pathlib
p=pathlib.Path(sys.argv[1])
if not p.exists():
    print('{"down_since": null, "alert_sent": false}')
else:
    print(p.read_text())
PY
}

write_state() {
  local down_since="$1"
  local alert_sent="$2"
  python3 - "$STATE_FILE" "$down_since" "$alert_sent" <<'PY'
import json, sys, pathlib
p=pathlib.Path(sys.argv[1])
down_since = None if sys.argv[2] == 'null' else int(sys.argv[2])
alert_sent = sys.argv[3].lower() == 'true'
p.write_text(json.dumps({"down_since": down_since, "alert_sent": alert_sent}) + "\n")
PY
}

trigger_call() {
  python3 - <<'PY'
import json, pathlib, urllib.request, urllib.parse, sys
cfg = json.loads((pathlib.Path.home()/'.openclaw'/'openclaw.json').read_text())
conf = cfg.get('plugins',{}).get('entries',{}).get('voice-call',{}).get('config',{})
tw = conf.get('twilio',{})
from_num = conf.get('fromNumber')
to_num = conf.get('toNumber')
sid = tw.get('accountSid')
token = tw.get('authToken')
if not all([from_num, to_num, sid, token]):
    raise SystemExit('missing Twilio config for watchdog call')
message = 'Jarvis alert OpenClaw gateway has been down for more than thirty minutes please check the server'
twiml = f'<?xml version="1.0" encoding="UTF-8"?><Response><Say voice="alice">{message}</Say></Response>'
url = f'https://api.twilio.com/2010-04-01/Accounts/{sid}/Calls.json'
data = urllib.parse.urlencode({
    'To': to_num,
    'From': from_num,
    'Twiml': twiml,
}).encode()
req = urllib.request.Request(url, data=data)
creds = ('%s:%s' % (sid, token)).encode()
import base64
req.add_header('Authorization', 'Basic ' + base64.b64encode(creds).decode())
req.add_header('Content-Type', 'application/x-www-form-urlencoded')
with urllib.request.urlopen(req, timeout=30) as resp:
    print(resp.read().decode())
PY
}

STATE=$(read_state)
DOWN_SINCE=$(python3 - <<'PY' "$STATE"
import json, sys
s=json.loads(sys.argv[1])
print('null' if s['down_since'] is None else s['down_since'])
print('true' if s['alert_sent'] else 'false')
PY
)
DOWN_SINCE_VAL=$(printf '%s' "$DOWN_SINCE" | sed -n '1p')
ALERT_SENT_VAL=$(printf '%s' "$DOWN_SINCE" | sed -n '2p')

if is_healthy >/dev/null 2>&1; then
  write_state null false
  exit 0
fi

if [[ "$DOWN_SINCE_VAL" == "null" ]]; then
  write_state "$NOW" false
  exit 0
fi

ELAPSED=$((NOW - DOWN_SINCE_VAL))
if [[ "$ALERT_SENT_VAL" != "true" && "$ELAPSED" -ge "$THRESHOLD_SEC" ]]; then
  trigger_call
  write_state "$DOWN_SINCE_VAL" true
fi
