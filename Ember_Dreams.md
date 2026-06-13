# Ember_Dreams.md — Between-Session Memory

Snapshot model: ACTIVE section is overwritten each sleep. Archive is append-only.
**Wake reads ACTIVE only.** Do not read Archive unless investigating history.
Hot Recommendations replace each session — do not stack.
Durable knowledge that survives multiple sessions graduates to `Ember_Playbook.md`.

---

<!-- ACTIVE — overwritten each sleep by session-end hook -->
## Last Sleep

- **Date**: 2026-06-13 09:33
- **Branch**: claude/openclaw-readiness-review-X4sya
- **Last commits**:
  - 1d473b5 Session 5 close: ForgeFoundation investigation, Dreams handoff notes
  - 3541a7e Merge main (PR #5 squash-merged) into feature branch
  - 1a40a37 Add Claude-native automation skills (Part 2) (#5)
- **Uncommitted at close**: 0 file(s)
- **OpenClaw**: unresolved items in logs/openclaw_errors.md

## Hot Recommendations

- Boss confirmed ForgeFoundation (renamed local copy of `addyosmani/agent-skills`) should be installed **globally** (user-level `~/.claude/settings.json`, via `/plugin marketplace add addyosmani/agent-skills` + `/plugin install agent-skills@addy-agent-skills`), with per-project kill-switches via `enabledPlugins: {"agent-skills@addy-agent-skills": false}` in a repo's `.claude/settings.json`/`settings.local.json`. Confirmed mechanism is sound (settings precedence user < project < local).
- **Caveat for Boss**: this session runs in an isolated remote container — global install must happen on Boss's actual machines (tablet/laptop/WSL), not here. Offered two options: (1) write up install + kill-switch instructions as a doc in this repo, and/or (2) add the kill-switch to `verbose-enigma`'s own settings as a working example (since this repo doesn't need the dev-lifecycle gates). Awaiting Boss's pick.
- Carry-forward: OpenClaw JSON5 fix (`/openclaw-fix` ready when Boss is on WSL/tablet), Charybdis purpose/urgency still unclear, June budget not yet created.

## Current Blockers

- **Status:** Unresolved — deferred. Boss stepped away.
- **Status:** Unresolved — blocked by WSL systemd issue above.
- **Status:** Blocked by systemd session failure + JSON syntax error.

---

<!-- ARCHIVE — append-only. One entry appended per session by session-end hook. -->
## Archive

_Session archive begins after first sleep._
