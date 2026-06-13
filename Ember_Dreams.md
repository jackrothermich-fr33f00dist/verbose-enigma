# Ember_Dreams.md — Between-Session Memory

Snapshot model: ACTIVE section is overwritten each sleep. Archive is append-only.
**Wake reads ACTIVE only.** Do not read Archive unless investigating history.
Hot Recommendations replace each session — do not stack.
Durable knowledge that survives multiple sessions graduates to `Ember_Playbook.md`.

---

<!-- ACTIVE — overwritten each sleep by session-end hook -->
## Last Sleep

- **Date**: 2026-06-13 03:19
- **Branch**: claude/openclaw-readiness-review-X4sya
- **Last commits**:
  - c9717d5 Add Claude-native automation skills (Part 2)
  - 66ba257 Merge pull request #4 from jackrothermich-fr33f00dist/claude/openclaw-readiness-review-X4sya
  - d390e58 Merge branch 'main' into claude/openclaw-readiness-review-X4sya
- **Uncommitted at close**: 0 file(s)
- **OpenClaw**: unresolved items in logs/openclaw_errors.md

## Hot Recommendations

- Part 2 done: six Claude-native skills now live under `.claude/skills/` — `health`, `briefing`, `openclaw-fix`, `finance-review`, `charybdis-checkin`, `market-research`. PR #5 is open as a draft against main, no CI configured, no review comments yet, still subscribed to its activity.
- Next session: review/merge PR #5 if Boss hasn't already, then do a first real run of `/health` and `/briefing` to validate the new skills against live Gmail/Calendar/ClickUp data.
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
