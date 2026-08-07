# Ember_Dreams.md — Between-Session Memory

Snapshot model: ACTIVE section is overwritten each sleep. Archive is append-only.
**Wake reads ACTIVE only.** Do not read Archive unless investigating history.
Hot Recommendations replace each session — do not stack.
Durable knowledge that survives multiple sessions graduates to `Ember_Playbook.md`.

---

<!-- ACTIVE — overwritten each sleep by session-end hook -->
## Last Sleep

- **Date**: 2026-08-07 07:02
- **Branch**: claude/bold-newton-9w2bxh
- **Last commits**:
  - 74bd922 Add Seedrasil chapter library: Bootstrap, Demon in the Clocks, Planting Kit, README draft
  - 52c6554 Update Dreams snapshot — session close
  - 4f946da Update Dreams snapshot — session close
- **Uncommitted at close**: 1 file(s)
- **OpenClaw**: unresolved items in logs/openclaw_errors.md

## Hot Recommendations

**Chapters/ folder is complete and pushed (PR #14, green CI).** All Seedrasil planning docs are now in one place:
- `Chapters/chapter-0-bootstrap.md` — full Bootstrap chronicle
- `Chapters/chapter-1-demon-in-the-clocks.md` — Demon in the Clocks roadmap
- `Chapters/Planting New Seedling Kit/` — kit index + original README verbatim
- `Chapters/FordrasilsSeedling-README-draft.md` — ready to publish to Seedrasil repo (Boss action)

**Before resuming Seedrasil**: 5 structural fixes required (Plugin Registry, Proposal Acceptance Tests, Stage Gates, Dead Code Gate, Honest Commit Messages) — all documented in chapter-0-bootstrap.md Bootstrap Audit section.

**PR #14** is draft, CI green, no review comments. Boss can merge when ready.

## Current Blockers

- **OpenClaw**: Unresolved items in `logs/openclaw_errors.md` (WSL systemd + Telegram token).
- **Roadmap date stale**: `plans/roadmap.md` still shows "Last updated: 2026-06-16".
- **Seedrasil paused**: intentionally, pending structural fixes. Boss decides when to resume.

---

<!-- ARCHIVE — append-only. One entry appended per session by session-end hook. -->
## Archive

_Session archive begins after first sleep._
