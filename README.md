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
