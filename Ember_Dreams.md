# Ember_Dreams.md — Between-Session Memory

Snapshot model: ACTIVE section is overwritten each sleep. Archive is append-only.
**Wake reads ACTIVE only.** Do not read Archive unless investigating history.
Hot Recommendations replace each session — do not stack.
Durable knowledge that survives multiple sessions graduates to `Ember_Playbook.md`.

---

<!-- ACTIVE — overwritten each sleep by session-end hook -->
## Last Sleep

- **Date**: 2026-06-13 13:55
- **Branch**: claude/openclaw-readiness-review-X4sya
- **Last commits**:
  - 73217ba Update Dreams snapshot (local-path install handoff notes)
  - 261f19c Add ForgeFoundation Claude setup doc and apply kill-switch to this repo
  - f5a9876 Update Dreams snapshot (ForgeFoundation global-install handoff)
- **Uncommitted at close**: 0 file(s)
- **OpenClaw**: unresolved items in logs/openclaw_errors.md

## Hot Recommendations

- Session 6 closed: ForgeFoundation Claude setup is done. `forgefoundation/CLAUDE_SETUP.md` documents installing from SuperDiskie's `01Skills` folder (local-path marketplace add, mount path varies per machine), with GitHub as fallback. Kill-switch applied to `verbose-enigma`'s own `.claude/settings.json` (`agent-skills@addy-agent-skills: false`).
- Boss action still needed: run the global install on each physical machine — `/plugin marketplace add "<SuperDiskie path>/01Skills"` + `/plugin install agent-skills@addy-agent-skills`. Cannot be done from this remote container.
- Carry-forward: OpenClaw JSON5 fix (`/openclaw-fix` ready when Boss is on WSL/tablet), Charybdis purpose/urgency still unclear, June budget not yet created.

## Current Blockers

- **Status:** Unresolved — deferred. Boss stepped away.
- **Status:** Unresolved — blocked by WSL systemd issue above.
- **Status:** Blocked by systemd session failure + JSON syntax error.

---

<!-- ARCHIVE — append-only. One entry appended per session by session-end hook. -->
## Archive

_Session archive begins after first sleep._
