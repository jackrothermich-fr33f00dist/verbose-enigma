# Ember_Dreams.md — Between-Session Memory

Snapshot model: ACTIVE section is overwritten each sleep. Archive is append-only.
**Wake reads ACTIVE only.** Do not read Archive unless investigating history.
Hot Recommendations replace each session — do not stack.
Durable knowledge that survives multiple sessions graduates to `Ember_Playbook.md`.

---

<!-- ACTIVE — overwritten each sleep by session-end hook -->
## Last Sleep

- **Date**: 2026-08-07 10:43
- **Branch**: claude/bold-newton-9w2bxh
- **Last commits**:
  - 6e9109b Retire OpenClaw: archive artifacts, scrub operational references
  - f078417 Revert "Remove OpenClaw — defunct, no longer part of the stack"
  - 53074f0 Remove OpenClaw — defunct, no longer part of the stack
- **Uncommitted at close**: 0 file(s)

## Hot Recommendations



## Current Blockers



---

<!-- ARCHIVE — append-only. One entry appended per session by session-end hook. -->
## Archive

_Session archive begins after first sleep._
