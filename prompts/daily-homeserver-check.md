Run the Jarvis homeserver daily operations check.

Checklist:
1. Run `openclaw status --deep`
2. Run `openclaw security audit --deep`
3. Run `openclaw update status`
4. Check disk, memory, uptime, load, and listening ports with safe read-only commands
5. Classify status as 정상 / 주의 / 긴급
6. If nothing notable changed, keep the report short
7. If there is risk or drift, clearly recommend the next action
8. Mention whether operator intervention is recommended

Output format:
- 상태:
- 요약:
- 세부:
  - OpenClaw
  - 보안
  - 리소스
  - 네트워크
- 추천 액션:
