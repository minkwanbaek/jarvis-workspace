# TOOLS.md - Local Notes

## Identity

- agent_name: Jarvis
- agent_name_ko: 자비스
- user_handle: mk

## Local Roles

- verifier: Researcher
- executor: Operator
- reviewer: Echo

## OpenClaw

- workspace_root: /home/javajinx7/.openclaw/workspace
- gateway_port: 18789
- gateway_health_cmd: openclaw gateway status
- second_brain_url: https://instance-20260308-084403.tail92230e.ts.net
- investment_bot_dashboard_url: https://instance-20260308-084403.tail92230e.ts.net/investment-bot
- investment_bot_dashboard_legacy_url: https://instance-20260308-084403.tail92230e.ts.net:8445/

## TTS

- preferred_voice: "coral" (via Eleven Labs)
- voice_call_provider: Twilio
- from_number: +17074148088
- to_number: +821021248116

## Socks Proxy

- socks5_proxy: socks5h://localhost:1080
- socks5_port: 1080
- blocked_domains:
  - reddit.com
  - www.reddit.com
  - old.reddit.com

## Monitoring Targets

- disk usage
- server load average
- gateway status
- cron recent failures
- unresolved decisions in MEMORY.md

## Skill Naming Notes

- keep the skill name `web-asis-analysis`
- do not rename it to `asispage` or other alternatives unless explicitly requested again
- keep brand-neutral internals/reference naming where possible even if the public skill name stays unchanged

## Email

- email_target: javajinx7@gmail.com
- smtp_server: <config not visible>

## YouTube

- subscriptions: 12 channels

## Notion

- main_page_id: 319e23c0-c14e-8001-ac64-f7db7d729a13

## Memory Search

- prefer local `memsearch` over OpenAI embeddings when practical
- current memsearch provider: `onnx`
- memsearch watcher service: `memsearch-watch`
- useful commands:
  - `memsearch search "<query>"`
  - `memsearch index /home/javajinx7/.openclaw/workspace/memory/ /home/javajinx7/.openclaw/workspace/MEMORY.md`
  - `systemctl --user status memsearch-watch`

---

<!-- Additions are environment-specific. Can refine further based on future updates. -->