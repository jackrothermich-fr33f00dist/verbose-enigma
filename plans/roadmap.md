# Forge Fire Roadmap — Ember's Operating Plan

Last updated: 2026-06-06

---

## Guiding Question

What creates the most happiness and value for Boss right now, given:
- Income disrupted (Chestnut termination Jan 2026)
- Active legal/grievance process → Charybdis evidence pipeline matters
- Selling 7707 Murdoch Ave
- Building Forge Fire as autonomous income engine
- Agent network (Athanor, Codex, Sinter, etc.) partially operational but fragile

---

## Phase 0 — Foundation (Current)

Get the infrastructure working so everything else can run autonomously.

| Item | Status | Notes |
|------|--------|-------|
| Ember_Playbook.md (persistent memory) | ✅ Done | |
| Repo structure (plans, logs, openclaw, tools) | ✅ Done | |
| OpenClaw config (openclaw.json, .env.template) | ✅ Done | Copy to tablet |
| Telegram channel config | ✅ Done | Needs bot token from Boss |
| Tablet troubleshooting guide | ✅ Done | See openclaw/SETUP.md |
| AGENTS.md (workspace context for OpenClaw) | ✅ Done | |
| Push to GitHub + PR | ✅ Done | PR #1 open |
| Boss follows SETUP.md on tablet | ⏳ Boss action | JSON5 fix + systemd fix first |
| Phone connected via Telegram | ⏳ Boss action | Blocked on OpenClaw fixes |

---

## Phase 1 — Situational Awareness

Survey what's actually happening so I can prioritize intelligently.

| Item | Status | Notes |
|------|--------|-------|
| ClickUp active tasks reviewed | ✅ Done | Key tasks: OpenClaw (86e1a42fj), WitnessVault (86e1mmfdj) |
| Gmail survey (what's urgent?) | ✅ Done | Facebook login alert (verify!), CC due Jun 13, income received |
| Calendar survey (what's coming?) | ✅ Done | Furnace filter Jun 7, Commerce CC $47 Jun 13 |
| Finance review (budget status, June gap) | ⏳ Next | June budget not yet created |
| Charybdis / legal status | 🔄 Partial | Pipeline scope clear; legal status/urgency unknown |
| LivingSpark Circuit Board review | ⏳ Needs D: drive access | Via SuperDiskie in ClickUp or file share |

---

## Phase 2 — High-Value Work

Priority order based on what I know so far. Will re-rank after Phase 1.

### 2A — Legal / Charybdis (potentially most urgent)
- **WitnessVault / Charybdis evidence custody pipeline** — active legal case against Chestnut; solid evidence organization is high-stakes
- Task: `86e1mmfdj` in ClickUp — reviewed. Pipeline: Phone A/V → WhisperBOT → SigilForge → OrcaVault → SuperDiskie → Jarvis
- Canonical project: `D:\02Domains\04Growth_Rings\01Charybdis\04WitnessVault_Project`
- Already done on D: drive: overview, roadmap, raw intake convention, custody manifest schema
- **Ember drafted (Jun 6)**: all four missing contracts in `charybdis/` folder — review and copy to D: drive
  - Processed vault manifest schema
  - WhisperBOT handoff contract
  - SigilForge bundle input contract
  - OrcaVault/SuperDiskie drop receipt contract
- **Guardrail**: no project movement, folder renaming, repo rerouting without Boss approval

### 2B — Income Generation
- **Growth Rings domain** — new business domain being scaffolded
- **WhisperBOT** — tool under Fordrasil, apparently monetizable
- **SecondMe** — digital twin (potential product)
- Market research: what do people pay for in the AI agent space right now?

### 2C — Agent Network Stability
- **Circuit Board Dashboard** — Boss needs visibility into all running agents
- **Athanor Playbook update** — keeps the agent stack documented and current
- **OpenClaw stability** — Phase 0, but ongoing

### 2D — Job Search Support
- Job search MCP is connected — can actively research roles, prep materials
- Only relevant if Boss wants employment parallel to Forge Fire

---

## Phase 3 — Autonomous Value Creation

Once OpenClaw is running and I have situational awareness, I can run scheduled tasks:

- **Daily briefing** (7am): calendar, ClickUp tasks, email summary → Telegram
- **Weekly market research** (Monday): what's trending in AI/agent space → Telegram
- **Charybdis check-in** (as needed): prompt Boss to log new evidence before it fades
- **Finance alert** (1st of month): flag if June budget not yet created

---

## Open Questions

- [ ] What is the actual D: drive path for the repo? (needed for `workspace` in openclaw.json)
- [x] What messaging channel does Boss prefer for proactive alerts? → Telegram confirmed
- [ ] What is the status of the Chestnut legal case? How urgent is Charybdis?
- [ ] Is there a specific income target or timeline for Forge Fire?
- [ ] Does Boss want me to search for jobs actively, or is Forge Fire the only path?
- [ ] Riverside.fm — is this for content creation / WhisperBOT integration, or personal?
- [ ] Facebook security alert (Jun 5) — was that login near St. Louis yours?

---

## Notes

- All Forge Fire active tasks live in ClickUp space `90173686954`
- Previous task system was Zenflow — migrated to ClickUp (tasks reference both)
- Sinter agent already has wake/sleep skills built (task `86e1gw755` marked complete)
