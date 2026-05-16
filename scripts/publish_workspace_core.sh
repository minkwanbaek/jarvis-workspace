#!/usr/bin/env bash
set -euo pipefail

SRC="/home/javajinx7/.openclaw/workspace"
PUB="/home/javajinx7/.openclaw/publish/jarvis-workspace"
REMOTE_URL="https://github.com/minkwanbaek/jarvis-workspace.git"
BRANCH="main"

info() {
  printf '[publish-workspace-core] %s\n' "$*"
}

require_cmd() {
  command -v "$1" >/dev/null 2>&1 || {
    echo "Missing required command: $1" >&2
    exit 1
  }
}

require_cmd git
require_cmd python3

info "Refreshing sanitized publish tree"
python3 - <<'PY'
import os, shutil, fnmatch
src='/home/javajinx7/.openclaw/workspace'
dst='/home/javajinx7/.openclaw/publish/jarvis-workspace'
if os.path.exists(dst):
    shutil.rmtree(dst)
os.makedirs(dst, exist_ok=True)

exclude_dirs={'.git','.openclaw','.clawhub','tmp','__pycache__','.pytest_cache','.mypy_cache','node_modules','.venv','venv','artifacts','archive','reports'}
exclude_globs=['*.pyc','memory/*password*','memory/*secret*','memory/*token*','memory/*smtp*','*.env','**/.env']

for dirpath, dirnames, filenames in os.walk(src):
    rel_dir=os.path.relpath(dirpath, src)
    if rel_dir == '.':
        rel_dir=''
    dirnames[:] = [d for d in dirnames if d not in exclude_dirs]
    out_dir=os.path.join(dst, rel_dir)
    os.makedirs(out_dir, exist_ok=True)
    for f in filenames:
        rel=os.path.join(rel_dir, f) if rel_dir else f
        if any(fnmatch.fnmatch(rel, g) or fnmatch.fnmatch(f, g) for g in exclude_globs):
            continue
        shutil.copy2(os.path.join(src, rel), os.path.join(dst, rel))
PY

info "Trimming to workspace-core"
python3 - <<'PY'
import os, shutil
root='/home/javajinx7/.openclaw/publish/jarvis-workspace'
keep_paths={
    'AGENTS.md','SOUL.md','USER.md','IDENTITY.md','MEMORY.md','HEARTBEAT.md','TOOLS.md',
    'JARVIS-HOMESERVER-MINIMAL-SETUP.md','JARVIS-HOMESERVER-OPERATIONS-V1.md',
    'JARVIS-MULTI-AGENT-DESIGN.md','JARVIS-OPERATING-RULES.md','JARVIS-OPERATOR-OPERATING-MODE-V1.md',
    'JARVIS-RESEARCHER-OPERATOR-FLOW-V1.md','GATEWAY-HEALTH-HANDLING.md',
    'VOICE-CALL-ALERT-RULES.md','VOICE-CALL-FIX-2026-03-10.md',
    'NOTION-OPERATING-RULES.md','JARVIS-WORKSPACE-CORE-PUBLISHING.md',
}
keep_dirs={'memory','prompts','scripts','systemd','team','skills','config'}
keep_memory={
    'memory/2026-03-10-homeserver-cron.md','memory/2026-03-11-ai-trading.md','memory/2026-03-11-copilot-fallback.md',
    'memory/2026-03-12-coupang-block.md','memory/2026-03-12-qmd-memory.md','memory/2026-03-12.md','memory/2026-03-13.md',
    'memory/system-profile-2026-03-12.md'
}
keep_prompts={'prompts/daily-homeserver-check.md'}
keep_scripts={'scripts/check_gateway_health.sh','scripts/check_gateway_outage.sh','scripts/publish_workspace_core.sh'}
keep_systemd={'systemd/user/openclaw-gateway-watchdog.service','systemd/user/openclaw-gateway-watchdog.timer'}
keep_team={'team/DECISIONS.md','team/GOALS.md','team/PROJECT_STATUS.md','team/agents/operator/HANDOFF.md','team/agents/operator/ROLE.md','team/agents/operator/SOUL.md'}
keep_config=set()
keep_skill_roots={'skills/ai-meeting-notes','skills/ai-proposal-generator','skills/github-cli','skills/gog','skills/nano-banana-pro','skills/notion','skills/proposal-generator'}

def should_keep(rel):
    rel=rel.strip('./')
    if rel in keep_paths or rel in keep_memory or rel in keep_prompts or rel in keep_scripts or rel in keep_systemd or rel in keep_team or rel in keep_config:
        return True
    for rootp in keep_skill_roots:
        if rel == rootp or rel.startswith(rootp + '/'):
            return True
    return False

for entry in list(os.listdir(root)):
    if entry == '.git' or entry == '.gitignore' or entry == 'README.md':
        continue
    full=os.path.join(root, entry)
    if os.path.isdir(full):
        if entry not in keep_dirs:
            shutil.rmtree(full, ignore_errors=True)
    elif entry not in keep_paths:
        os.remove(full)

for dirpath, dirnames, filenames in os.walk(root, topdown=False):
    rel_dir=os.path.relpath(dirpath, root)
    if rel_dir == '.':
        continue
    for f in filenames:
        rel=os.path.join(rel_dir, f)
        if not should_keep(rel):
            try: os.remove(os.path.join(root, rel))
            except FileNotFoundError: pass
    for d in dirnames:
        rel=os.path.join(rel_dir, d)
        full=os.path.join(root, rel)
        try:
            if os.path.isdir(full) and not os.listdir(full):
                os.rmdir(full)
        except OSError:
            pass
PY

info "Writing README and .gitignore"
cat > "$PUB/README.md" <<'EOF'
# jarvis-workspace

Sanitized, private **workspace-core** snapshot for Jarvis (자비스), an OpenClaw-based personal secretary / operations assistant.

## What this repo is

This repository is **not** a full machine backup.
It is a curated workspace snapshot containing the durable files that shape Jarvis's identity, operating rules, memory discipline, selected runbooks, prompts, scripts, and reusable skills.

## Included

- Core workspace files: `AGENTS.md`, `SOUL.md`, `USER.md`, `IDENTITY.md`, `MEMORY.md`, `HEARTBEAT.md`, `TOOLS.md`
- Selected operating docs and runbooks
- Selected memory notes useful for durable context
- Selected prompts, scripts, and systemd units
- Selected reusable skills and configuration

## Excluded

This published snapshot intentionally excludes or trims:

- credentials, tokens, secrets, `.env` files
- OpenClaw state/config internals such as `.openclaw/`
- temp files, generated reports, archives, and other stateful outputs
- broad project trees that are not needed for workspace-core backup/sharing
- memory files containing sensitive credentials or overly local operational details

## Publishing rule

When updating this repository, prefer:

1. durable operating knowledge
2. reusable prompts / scripts / skills
3. sanitized documentation

Avoid publishing:

1. live credentials or secret-bearing files
2. raw generated assets unless intentionally shareable
3. local machine state or transient outputs
4. anything that would make future secret rotation necessary

## Notes

- Default assistant name: `Jarvis` / `자비스`
- Default user address: `엠케이님`
- This repo is intended to stay **private** unless explicitly reviewed for wider sharing.
EOF
cat > "$PUB/.gitignore" <<'EOF'
.openclaw/
.clawhub/
tmp/
__pycache__/
*.pyc
archive/
reports/
.env
**/.env
memory/*password*
memory/*secret*
memory/*token*
memory/*smtp*
EOF

info "Running lightweight secret scan"
python3 - <<'PY'
import os,re,fnmatch,sys
root='/home/javajinx7/.openclaw/publish/jarvis-workspace'
content_patterns=[
    r'gh[pousr]_[A-Za-z0-9]{20,}',
    r'github_pat_[A-Za-z0-9_]{20,}',
    r'sk-[A-Za-z0-9]{20,}',
    r'AIza[0-9A-Za-z\-_]{20,}',
    r'AKIA[0-9A-Z]{16}',
    r'-----BEGIN (?:RSA|EC|OPENSSH|DSA|PGP) PRIVATE KEY-----',
    r'xox[baprs]-[A-Za-z0-9-]{20,}',
    r'(?i)upbit.{0,20}(secret|access).{0,10}[:=].{0,80}',
    r'(?i)(smtp|imap).{0,20}(password|pass|token).{0,10}[:=].{0,80}',
]
exclude_globs=['*.png','*.jpg','*.jpeg','*.gif','*.webp','*.pdf','*.db','*.sqlite*']
rxs=[re.compile(p) for p in content_patterns]
findings=[]
for dirpath, _, filenames in os.walk(root):
    for f in filenames:
        rel=os.path.relpath(os.path.join(dirpath,f),root)
        if rel.startswith('.git/'):
            continue
        if any(fnmatch.fnmatch(rel,g) or fnmatch.fnmatch(f,g) for g in exclude_globs):
            continue
        try:
            txt=open(os.path.join(root,rel),'r',encoding='utf-8',errors='ignore').read()
        except:
            continue
        for rx in rxs:
            if rx.search(txt):
                findings.append(rel)
                break
for rel in findings[:20]:
    print(rel)
print(f'COUNT {len(findings)}')
PY

info "Rebuilding git repo and pushing"
rm -rf "$PUB/.git"
git -C "$PUB" init -b "$BRANCH" >/dev/null
name=$(git -C "$SRC" config user.name || true)
email=$(git -C "$SRC" config user.email || true)
[ -n "$name" ] || name='mk'
[ -n "$email" ] || email='javajinx7@gmail.com'
git -C "$PUB" config user.name "$name"
git -C "$PUB" config user.email "$email"
git -C "$PUB" add .
git -C "$PUB" commit -m "refresh workspace-core publish snapshot" >/dev/null
git -C "$PUB" remote add origin "$REMOTE_URL"
git -C "$PUB" push -u origin "$BRANCH" --force

info "Done"
