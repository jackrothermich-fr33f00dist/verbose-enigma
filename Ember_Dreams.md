# Ember_Dreams.md — Between-Session Memory

Snapshot model: ACTIVE section is overwritten each sleep. Archive is append-only.
**Wake reads ACTIVE only.** Do not read Archive unless investigating history.
Hot Recommendations replace each session — do not stack.
Durable knowledge that survives multiple sessions graduates to `Ember_Playbook.md`.

---

<!-- ACTIVE — overwritten each sleep by session-end hook -->
## Last Sleep

- **Date**: 2026-06-13 09:25
- **Branch**: claude/openclaw-readiness-review-X4sya
- **Last commits**:
  - 3541a7e Merge main (PR #5 squash-merged) into feature branch
  - 1a40a37 Add Claude-native automation skills (Part 2) (#5)
  - 171f733 Fix session-end hook to use SessionEnd instead of Stop
- **Uncommitted at close**: 0 file(s)
- **OpenClaw**: unresolved items in logs/openclaw_errors.md

## Hot Recommendations

- Boss asked about "ForgeFoundation" — investigated and identified it as Boss's renamed local copy (E: drive, `Entities/Fordrasil's Trunk/Skills/`) of the public `addyosmani/agent-skills` Claude Code plugin (workflow commands `/spec → /plan → /build → /test → /review → /ship`, agent personas, and a SessionStart-only hook).
- Recommended NOT installing it into `verbose-enigma` — this repo is Ember's ops/memory repo, not a "ship code features" codebase, so the dev-lifecycle quality gates don't map well here. Better fit: install ForgeFoundation into an actual Forge Fire product repo (WhisperBOT, Growth Rings tooling, dashboards) once one exists.
- Boss's `UserPromptSubmit` idea (ping ForgeFoundation as a quality-gate check every turn) — flagged that the upstream plugin has no such hook; we'd be building it custom, and it'd add per-turn latency. Awaiting Boss's decision on whether/where to pursue this.
- Carry-forward: OpenClaw JSON5 fix (`/openclaw-fix` ready when Boss is on WSL/tablet), Charybdis purpose/urgency still unclear, June budget not yet created.

## Current Blockers

- **Status:** Unresolved — deferred. Boss stepped away.
- **Status:** Unresolved — blocked by WSL systemd issue above.
- **Status:** Blocked by systemd session failure + JSON syntax error.

---

<!-- ARCHIVE — append-only. One entry appended per session by session-end hook. -->
## Archive

_Session archive begins after first sleep._
