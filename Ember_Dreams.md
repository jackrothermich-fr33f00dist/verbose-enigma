# Ember_Dreams.md — Between-Session Memory

Snapshot model: ACTIVE section is overwritten each sleep. Archive is append-only.
**Wake reads ACTIVE only.** Do not read Archive unless investigating history.
Hot Recommendations replace each session — do not stack.
Durable knowledge that survives multiple sessions graduates to `Ember_Playbook.md`.

---

<!-- ACTIVE — overwritten each sleep by session-end hook -->
## Last Sleep

- **Date**: 2026-06-26 23:36
- **Branch**: claude/bold-newton-9w2bxh
- **Last commits**:
  - 99467e3 Update Dreams snapshot
  - c35688f Resolve EOS-4: send_later unavailable, ScheduleWakeup isn't a substitute
  - c0239d6 Complete EOS-7: OpenClaw alternatives research + research-compare skill
- **Uncommitted at close**: 1 file(s)
- **OpenClaw**: unresolved items in logs/openclaw_errors.md

## Hot Recommendations

_[Ember: replace this with your actual handoff notes before closing]_

## Current Blockers

- **Status:** Unresolved — deferred. Boss stepped away.
- **Status:** Unresolved — blocked by WSL systemd issue above.
- **Status:** Blocked by systemd session failure + JSON syntax error.

---

<!-- ARCHIVE — append-only. One entry appended per session by session-end hook. -->
## Archive

_Session archive begins after first sleep._
