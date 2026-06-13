# Ember_Dreams.md — Between-Session Memory

Snapshot model: ACTIVE section is overwritten each sleep. Archive is append-only.
**Wake reads ACTIVE only.** Do not read Archive unless investigating history.
Hot Recommendations replace each session — do not stack.
Durable knowledge that survives multiple sessions graduates to `Ember_Playbook.md`.

---

<!-- ACTIVE — overwritten each sleep by session-end hook -->
## Last Sleep

- **Date**: 2026-06-12 22:00
- **Branch**: claude/openclaw-readiness-review-X4sya
- **Last commits**:
  - fb976a4 Session 3 close: add session close routine, update activity log
  - aed7252 Add SessionStart hook: auto-inject Ember_Playbook.md at session start
  - 504145d Remove incomplete run skill (not needed)
- **Uncommitted at close**: 4 file(s)
- **OpenClaw**: unresolved items in logs/openclaw_errors.md

## Hot Recommendations

- Wake/sleep automation now live: SessionStart hook injects Playbook + Dreams ACTIVE section; Stop hook snapshots session facts into this file. No more manual context priming needed.
- Part 2 complete: six Claude-native skills now exist under `.claude/skills/` — `health`, `briefing`, `openclaw-fix`, `finance-review`, `charybdis-checkin`, `market-research`. None have been invoked yet — first real use will show if they need tuning (especially `/briefing` and `/finance-review`'s MCP tool usage).
- Next session: try running `/health` and `/briefing` to validate the new skills, and pick up a Phase 2B (income) item with `/market-research`.
- Fix OpenClaw JSON5 error (line 164) — only thing blocking Telegram/gateway (still deferred, needs Boss on WSL/tablet) — `/openclaw-fix` is ready to walk this when Boss is on WSL
- Review Charybdis purpose/urgency with Boss — pipeline scope is clear, but the "why" is still unknown
- June budget not yet created — flag again if still missing

## Current Blockers

- **Status:** Unresolved — deferred. Boss stepped away.
- **Status:** Unresolved — blocked by WSL systemd issue above.
- **Status:** Blocked by systemd session failure + JSON syntax error.

---

<!-- ARCHIVE — append-only. One entry appended per session by session-end hook. -->
## Archive

_Session archive begins after first sleep._
