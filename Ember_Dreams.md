# Ember_Dreams.md — Between-Session Memory

Snapshot model: ACTIVE section is overwritten each sleep. Archive is append-only.
**Wake reads ACTIVE only.** Do not read Archive unless investigating history.
Hot Recommendations replace each session — do not stack.
Durable knowledge that survives multiple sessions graduates to `Ember_Playbook.md`.

---

<!-- ACTIVE — overwritten each sleep by session-end hook -->
## Last Sleep

- **Date**: 2026-08-07
- **Branch**: claude/bold-newton-9w2bxh
- **Delivered this session**:
  - `Chapters/chapter-0-bootstrap.md` — full chapter write, word-for-word chronicle of Bootstrap
  - `Chapters/chapter-1-demon-in-the-clocks.md` — "A Demon in the Clocks" (moved from plans/)
  - `Chapters/Planting New Seedling Kit/STARTER_README.md` — original FordrasilsSeedling README preserved verbatim
  - `Chapters/Planting New Seedling Kit/README.md` — kit index with setup checklist and governance decisions
  - `Chapters/FordrasilsSeedling-README-draft.md` — new accurate README draft for FordrasilsSeedling, summarizing both chapters and linking to Chapters/ structure
- **OpenClaw**: unresolved items in logs/openclaw_errors.md

## Hot Recommendations

**Chapters/ folder is complete.** Next natural step: review `FordrasilsSeedling-README-draft.md` and decide whether to publish it to the FordrasilsSeedling repo. Boss action required to publish.

**Structural fixes before resuming Seedrasil** — five items documented in `Chapters/chapter-0-bootstrap.md` (Bootstrap Audit section) and Chapter 1. These are one human session each. Seedrasil should not resume autonomous operation until at least Fix 1 (Plugin Registry) and Fix 2 (Proposal Acceptance Tests) are in place.

**plans/seedrasil-demon-in-the-clocks.md** still exists in plans/ (legacy location). Can be deleted if Chapters/ is now canonical — or leave as a redirect note.

## Current Blockers

- **OpenClaw**: Unresolved items in `logs/openclaw_errors.md` (WSL systemd + Telegram token).
- **Roadmap date stale**: `plans/roadmap.md` still shows "Last updated: 2026-06-16".
- **Seedrasil paused**: intentionally, pending structural fixes. Boss decides when to resume.

---

<!-- ARCHIVE — append-only. One entry appended per session by session-end hook. -->
## Archive

_Session archive begins after first sleep._
