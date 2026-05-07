# HEARTBEAT.md

<!-- 주기 점검용 -->

## Schedule

- every: 30m

## Source of Truth

- policy doc: `/home/javajinx7/.openclaw/workspace/MONITORING-BOT.md`
- config: `/home/javajinx7/.openclaw/workspace/config/monitoring-bot-services.json`
- runner: `/home/javajinx7/.openclaw/workspace/scripts/run_monitoring_bot.sh`
- core: `/home/javajinx7/.openclaw/workspace/scripts/monitoring_bot_run.py`
- systemd user timer: `monitoring-bot.timer`
- systemd user service: `monitoring-bot.service` (oneshot, may be inactive between runs)

## Checks

1. run `systemctl --user is-active monitoring-bot.timer`
2. run `curl -fsS http://127.0.0.1:8899/health`
3. run `curl -fsS http://127.0.0.1:3001/`

## Output

- all normal -> HEARTBEAT_OK
- otherwise -> report only abnormal items

## Notes

- `monitoring-bot.service` is `Type=oneshot`; inactive between runs is normal
- legacy `self-heal` / `automation-quality` scripts and cron jobs are retired intentionally
- do not treat missing `self_heal_check.py` or `self_heal_report.py` as an alert
