# Ember_Dreams.md — Between-Session Memory

Snapshot model: ACTIVE section is overwritten each sleep. Archive is append-only.
**Wake reads ACTIVE only.** Do not read Archive unless investigating history.
Hot Recommendations replace each session — do not stack.
Durable knowledge that survives multiple sessions graduates to `Ember_Playbook.md`.

---

<!-- ACTIVE — overwritten each sleep by session-end hook -->
## Last Sleep

- **Date**: 2026-06-13 11:57
- **Branch**: claude/openclaw-readiness-review-X4sya
- **Last commits**:
  - f5a9876 Update Dreams snapshot (ForgeFoundation global-install handoff)
  - 1d473b5 Session 5 close: ForgeFoundation investigation, Dreams handoff notes
  - 3541a7e Merge main (PR #5 squash-merged) into feature branch
- **Uncommitted at close**: 2 file(s)
- **OpenClaw**: unresolved items in logs/openclaw_errors.md

## Hot Recommendations

- ForgeFoundation setup done: `forgefoundation/CLAUDE_SETUP.md` documents the global install (`/plugin marketplace add` + `/plugin install agent-skills@addy-agent-skills` on each of Boss's machines) and the per-project kill-switch syntax.
- Kill-switch applied to `verbose-enigma` itself: `.claude/settings.json` now has `"enabledPlugins": {"agent-skills@addy-agent-skills": false}` — demonstrates the pattern and keeps this ops repo free of the dev-lifecycle gates.
- Reminder for Boss: the global install step still needs to be run manually on each physical machine (tablet/laptop/WSL) — I can't do that from this remote container.
- Carry-forward: OpenClaw JSON5 fix (`/openclaw-fix` ready when Boss is on WSL/tablet), Charybdis purpose/urgency still unclear, June budget not yet created.

## Current Blockers

- **Status:** Unresolved — deferred. Boss stepped away.
- **Status:** Unresolved — blocked by WSL systemd issue above.
- **Status:** Blocked by systemd session failure + JSON syntax error.

---

<!-- ARCHIVE — append-only. One entry appended per session by session-end hook. -->
## Archive

_Session archive begins after first sleep._
