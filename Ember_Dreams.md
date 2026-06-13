# Ember_Dreams.md — Between-Session Memory

Snapshot model: ACTIVE section is overwritten each sleep. Archive is append-only.
**Wake reads ACTIVE only.** Do not read Archive unless investigating history.
Hot Recommendations replace each session — do not stack.
Durable knowledge that survives multiple sessions graduates to `Ember_Playbook.md`.

---

<!-- ACTIVE — overwritten each sleep by session-end hook -->
## Last Sleep

- **Date**: 2026-06-13 12:08
- **Branch**: claude/openclaw-readiness-review-X4sya
- **Last commits**:
  - 261f19c Add ForgeFoundation Claude setup doc and apply kill-switch to this repo
  - f5a9876 Update Dreams snapshot (ForgeFoundation global-install handoff)
  - 1d473b5 Session 5 close: ForgeFoundation investigation, Dreams handoff notes
- **Uncommitted at close**: 0 file(s)
- **OpenClaw**: unresolved items in logs/openclaw_errors.md

## Hot Recommendations

- ForgeFoundation setup committed (261f19c): `forgefoundation/CLAUDE_SETUP.md` + kill-switch in `verbose-enigma`'s `.claude/settings.json` (`"enabledPlugins": {"agent-skills@addy-agent-skills": false}`).
- Boss asked whether install works from the already-downloaded local copy (E: drive `ForgeFoundation`). Confirmed: `/plugin marketplace add <local-path>` works if `.claude-plugin/marketplace.json` exists at the root, but local paths don't auto-update (no sync with upstream `addyosmani/agent-skills`) — GitHub URL recommended if Boss wants updates. Offered to add this local-path option to `CLAUDE_SETUP.md` but Boss hasn't confirmed yet.
- Carry-forward: OpenClaw JSON5 fix (`/openclaw-fix` ready when Boss is on WSL/tablet), Charybdis purpose/urgency still unclear, June budget not yet created.

## Current Blockers

- **Status:** Unresolved — deferred. Boss stepped away.
- **Status:** Unresolved — blocked by WSL systemd issue above.
- **Status:** Blocked by systemd session failure + JSON syntax error.

---

<!-- ARCHIVE — append-only. One entry appended per session by session-end hook. -->
## Archive

_Session archive begins after first sleep._
