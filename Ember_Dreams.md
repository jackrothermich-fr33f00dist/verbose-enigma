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
- **Last commits**:
  - 4f946da Update Dreams snapshot — session close
  - 82b6820 Update Dreams snapshot
  - 95d6cbe Update Dreams snapshot
- **Uncommitted at close**: 0 file(s)
- **OpenClaw**: unresolved items in logs/openclaw_errors.md

## Hot Recommendations

**PRIMARY TASK: "A Demon in the Clocks"** — 4-phase roadmap chapter for FordrasilsSeedling's next evolution (giving Seedrasil OpenClaw-like persistent/event-driven/phone-reach capabilities). Save to `plans/seedrasil-demon-in-the-clocks.md`. Do NOT publish to FordrasilsSeedling repo.

**Blocker**: Need to read FordrasilsSeedling. Options:
1. Tailscale SMB mount `//100.107.39.71/S-Fordrasil` — needs fresh ephemeral auth key + FyreHeart-Forge online. Revoke old keys first.
2. GitHub MCP `add_repo` — not available in this session type.

**To unblock next session**: Ask Boss if FyreHeart-Forge is online, request fresh ephemeral `tag:jack` auth key, run `/tailscale-connect`, then prompt Boss to run mount command with their credentials.

## Current Blockers

- **"A Demon in the Clocks"**: Waiting on FyreHeart-Forge online + SMB mount to read FordrasilsSeedling.
- **OpenClaw**: Unresolved items in `logs/openclaw_errors.md` (WSL systemd + Telegram token).
- **Roadmap date stale**: `plans/roadmap.md` still shows "Last updated: 2026-06-16".

---

<!-- ARCHIVE — append-only. One entry appended per session by session-end hook. -->
## Archive

_Session archive begins after first sleep._
