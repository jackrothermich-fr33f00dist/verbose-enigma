# Ember_Dreams.md — Between-Session Memory

Snapshot model: ACTIVE section is overwritten each sleep. Archive is append-only.
**Wake reads ACTIVE only.** Do not read Archive unless investigating history.
Hot Recommendations replace each session — do not stack.
Durable knowledge that survives multiple sessions graduates to `Ember_Playbook.md`.

---

<!-- ACTIVE — overwritten each sleep by session-end hook -->
## Last Sleep

- **Date**: 2026-08-07 13:19
- **Branch**: claude/bold-newton-9w2bxh
- **Last commits**:
  - f9e21e2 Session 15: FordrasilsSeedling reorganize — PR #54 opened; update Dreams handoff
  - af76bc7 Log session 14 activity; update Dreams handoff
  - 6845394 Update Dreams snapshot — session close
- **Uncommitted at close**: 0 file(s)

## Hot Recommendations

- FordrasilsSeedling PR #54 (ember/seedling-reorganize) — letter renamed to 13MAIL_003, eval scan done. Ready for Boss review/merge.
- 3 large log files need manual `git mv` (too large for API) — see PR #54 description for commands.
- session-end.sh deletion still pending — Boss must explicitly say "delete `.claude/hooks/session-end.sh`" to unblock.

## Current Blockers

- Boss merge decision on PR #54
- `02evals/eval_tailscale_key_revocation.py` calls real `tailscale up` subprocess — harmful if loop resumes before fixed
- `eval_overview_auditor_validation.py` and `eval_003_benchmark.py` have broken imports that will crash the eval runner



---

<!-- ARCHIVE — append-only. One entry appended per session by session-end hook. -->
## Archive

_Session archive begins after first sleep._
