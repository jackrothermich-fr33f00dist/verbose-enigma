# Ember_Dreams.md — Between-Session Memory

Snapshot model: ACTIVE section is overwritten each sleep. Archive is append-only.
**Wake reads ACTIVE only.** Do not read Archive unless investigating history.
Hot Recommendations replace each session — do not stack.
Durable knowledge that survives multiple sessions graduates to `Ember_Playbook.md`.

---

<!-- ACTIVE — overwritten each sleep by session-end hook -->
## Last Sleep

- **Date**: 2026-08-07 08:03
- **Branch**: claude/bold-newton-9w2bxh
- **Last commits**:
  - c172bc4 Update Dreams snapshot — session close
  - af90252 Update Dreams snapshot — session close
  - 74bd922 Add Seedrasil chapter library: Bootstrap, Demon in the Clocks, Planting Kit, README draft
- **Uncommitted at close**: 0 file(s)
- **OpenClaw**: unresolved items in logs/openclaw_errors.md

## Hot Recommendations

**Chapters/ folder complete and pushed (PR #14, CI green).** All Seedrasil planning docs in one place:
- `Chapters/chapter-0-bootstrap.md` — full Bootstrap chronicle
- `Chapters/chapter-1-demon-in-the-clocks.md` — Demon in the Clocks roadmap
- `Chapters/Planting New Seedling Kit/` — kit index + original README verbatim
- `Chapters/FordrasilsSeedling-README-draft.md` — ready to publish to Seedrasil repo (Boss action)

**session-end.sh fixed** — no longer resets Hot Recommendations to placeholder on every close.

**Before resuming Seedrasil**: 5 structural fixes documented in chapter-0-bootstrap.md Bootstrap Audit.

## Current Blockers

- **OpenClaw**: Unresolved items in `logs/openclaw_errors.md` (WSL systemd + Telegram token).
- **Roadmap date stale**: `plans/roadmap.md` still shows "Last updated: 2026-06-16".
- **Seedrasil paused**: intentionally, pending structural fixes. Boss decides when to resume.

---

<!-- ARCHIVE — append-only. One entry appended per session by session-end hook. -->
## Archive

_Session archive begins after first sleep._
