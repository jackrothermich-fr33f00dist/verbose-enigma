# Ember_Dreams.md — Between-Session Memory

Snapshot model: ACTIVE section is overwritten each sleep. Archive is append-only.
**Wake reads ACTIVE only.** Do not read Archive unless investigating history.
Hot Recommendations replace each session — do not stack.
Durable knowledge that survives multiple sessions graduates to `Ember_Playbook.md`.

---

<!-- ACTIVE — overwritten each sleep by session-end hook -->
## Last Sleep

- **Date**: 2026-08-07 13:00
- **Branch**: claude/bold-newton-9w2bxh
- **Last commits**:
  - af76bc7 Log session 14 activity; update Dreams handoff
- **Uncommitted at close**: 0 file(s)

## Hot Recommendations

- FordrasilsSeedling PR #54 (ember/seedling-reorganize) open — draft, Boss needs to approve deletions of originals at old paths. List is in PR description.
- session-end.sh deletion still pending — Boss must explicitly say "delete `.claude/hooks/session-end.sh`" to unblock.

## Current Blockers

- Boss deletion approval needed for: 7 root-level originals in FordrasilsSeedling, 3 stale Python files in `00Correspondence/`, 2 large log files (manual git mv needed). All listed in PR #54.



---

<!-- ARCHIVE — append-only. One entry appended per session by session-end hook. -->
## Archive

_Session archive begins after first sleep._
