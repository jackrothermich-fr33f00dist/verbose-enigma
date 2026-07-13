# Ember_Dreams.md — Between-Session Memory

Snapshot model: ACTIVE section is overwritten each sleep. Archive is append-only.
**Wake reads ACTIVE only.** Do not read Archive unless investigating history.
Hot Recommendations replace each session — do not stack.
Durable knowledge that survives multiple sessions graduates to `Ember_Playbook.md`.

---

<!-- ACTIVE — overwritten each sleep by session-end hook -->
## Last Sleep

- **Date**: 2026-07-13 04:20
- **Branch**: claude/bold-newton-9w2bxh
- **Last commits**:
  - 82b6820 Update Dreams snapshot
  - 95d6cbe Update Dreams snapshot
  - f6aba33 Add tailscale-connect skill (01Skills + .claude/skills)
- **Uncommitted at close**: 0 file(s)
- **OpenClaw**: unresolved items in logs/openclaw_errors.md

## Hot Recommendations

**PRIMARY TASK: "A Demon in the Clocks"** — Write 4-phase roadmap chapter for FordrasilsSeedling's next evolution phase (giving Seedrasil OpenClaw-like persistent/event-driven/phone-reach capabilities). Save to `plans/seedrasil-demon-in-the-clocks.md` + mirror to `01Skills/` if applicable. Do NOT publish to FordrasilsSeedling repo.

To do this, need to read FordrasilsSeedling. Options:
1. Mount `//100.107.39.71/S-Fordrasil` via Tailscale SMB (preferred — Boss working on ACL/Tailscale entrance to S:). Share name: `S-Fordrasil`. Boss runs mount command themselves with credentials.
2. Use GitHub MCP if FordrasilsSeedling gets added to session scope (currently blocked — not in scope list, `add_repo` not available this session type).

**Tailscale status this session**: Connected as claude-cloud (100.96.196.103) on jackrothermich@gmail.com tailnet. FyreHeart-Forge (100.107.39.71) not appearing as peer — Boss updated ACL tag but FyreHeart-Forge may be offline/sleeping. Check `tailscale status` at next session start; if FyreHeart-Forge appears, prompt Boss for mount.

**Auth key**: Boss generated new ephemeral key tagged `tag:jack`. Both previous keys should be revoked in Tailscale admin console.

## Current Blockers

- **"A Demon in the Clocks"**: Blocked on FordrasilsSeedling content. FyreHeart-Forge not visible as Tailscale peer this session. Needs FyreHeart-Forge online + SMB mount.
- **OpenClaw**: Unresolved items in `logs/openclaw_errors.md` (WSL systemd + Telegram token).
- **Roadmap date stale**: `plans/roadmap.md` still shows "Last updated: 2026-06-16" — update when next making roadmap changes.

---

<!-- ARCHIVE — append-only. One entry appended per session by session-end hook. -->
## Archive

_Session archive begins after first sleep._
