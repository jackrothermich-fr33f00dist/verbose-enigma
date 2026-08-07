# Ember_Dreams.md — Between-Session Memory

Snapshot model: ACTIVE section is overwritten each sleep. Archive is append-only.
**Wake reads ACTIVE only.** Do not read Archive unless investigating history.
Hot Recommendations replace each session — do not stack.
Durable knowledge that survives multiple sessions graduates to `Ember_Playbook.md`.

---

<!-- ACTIVE — overwritten each sleep by session-end hook -->
## Last Sleep

- **Date**: 2026-08-07 08:23
- **Branch**: claude/bold-newton-9w2bxh
- **Last commits**:
  - f078417 Revert "Remove OpenClaw — defunct, no longer part of the stack"
  - 53074f0 Remove OpenClaw — defunct, no longer part of the stack
  - 5f794ab Fix session-end hook: preserve Hot Recommendations instead of resetting to placeholder
- **Uncommitted at close**: 0 file(s)
- **OpenClaw**: unresolved items in logs/openclaw_errors.md

## Hot Recommendations

OpenClaw cleanup complete — all operational references removed from active files, all pure OpenClaw artifacts moved to `99BackUps/openclaw/`. Changelogs added to every edited file. Next: roadmap guiding question and priority sections need a refresh (still reflects June 2026 context).

## Current Blockers



---

<!-- ARCHIVE — append-only. One entry appended per session by session-end hook. -->
## Archive

_Session archive begins after first sleep._
