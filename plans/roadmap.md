# Forge Fire Roadmap — Ember's Operating Plan

Last updated: 2026-06-12

---

## Guiding Question

What creates the most happiness and value for Boss right now, given:
- Income disrupted (Chestnut termination Jan 2026)
- Active legal/grievance process → Charybdis evidence pipeline matters
- Selling 7707 Murdoch Ave
- Building Forge Fire as autonomous income engine
- Agent network (Athanor, Codex, Sinter, etc.) partially operational but fragile

---

## Overarching Finance Goal (added 2026-06-13)

**Replace manual monthly budget spreadsheets with Discreet Ledger
(orcav.io/ledger) going forward.** The xlsx/csv workbooks in Drive's
"2025 Budgets" folder (and the `06JUN2026` sheet created this session) are a
**stopgap only** — the target end-state is Boss logging transactions directly
in the live ledger app, with this repo's consolidated CSV (`finances/`) used
once to backfill 2025 history.

**Correction (2026-06-13, later)**: repo access alone does NOT solve this.
The `expense_tracker` repo is source code — it has no path to the *live*
deployed app's database. Actually pushing data into orcav.io/ledger requires
either (a) an authenticated API call against the running instance, or (b)
driving the UI via a browser. This session has neither: no browser/computer-use
tool, and WebFetch can't run JS or hold a login session.

**Realistic plan given actual toolset**: this agent cannot automate the
upload. The deliverable is a clean, ready-to-import file plus instructions —
Boss does the actual import via the ledger's UI (one-time, ~64 rows).
Reading the `expense_tracker` repo (if ever in scope) would still be useful
to learn the exact expected import format/columns so the CSV can be
reshaped to match exactly, but it's a "nice to have for formatting," not the
core blocker anymore.

**Next step**: ask Boss what format the ledger's import feature (if any)
expects, or have Boss do a one-time manual entry/import of
`finances/2025_transactions_jul_oct.csv` (64 rows, Jul-Oct 2025) and
`06JUN2026` going forward. After that, the manual budget-sheet workflow can
be retired per the overarching goal above.

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
| Finance review (budget status, June gap) | 🔄 Partial | Jul-Oct 2025 consolidated to `finances/2025_transactions_jul_oct.csv`; created empty `06JUN2026` budget sheet in Drive (standardized schema) since none existed |
| Charybdis / legal status | 🔄 Partial | Pipeline scope clear; legal status/urgency unknown |
| LivingSpark Circuit Board review | ⏳ Needs D: drive access | Via SuperDiskie in ClickUp or file share |

---

## Phase 2 — High-Value Work

Priority order based on what I know so far. Will re-rank after Phase 1.

### 2A — Legal / Charybdis (potentially most urgent)
- **WitnessVault / Charybdis evidence custody pipeline** — evidence organization pipeline; nature/urgency unclear, ask Boss
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

**Update (2026-06-12)**: Boss redirected this phase away from OpenClaw/Telegram. Wake/sleep
automation is now handled natively via Claude Code hooks (SessionStart/Stop +
`Ember_Dreams.md`) — done, see Phase 0. The items below become on-demand
Claude-native skills/routines run within sessions, not scheduled Telegram alerts:

| Item | Status | Notes |
|------|--------|-------|
| Wake/sleep session memory (hooks + Ember_Dreams.md) | ✅ Done | SessionStart injects Playbook+Dreams; Stop hook snapshots state |
| `/briefing` skill — Gmail + Calendar + ClickUp survey | ✅ Done | `.claude/skills/briefing/` — on-demand, replaces "daily briefing → Telegram" |
| `/health` skill — workspace health check | ✅ Done | `.claude/skills/health/` |
| `/openclaw-fix` skill — recovery checklist walkthrough | ✅ Done | `.claude/skills/openclaw-fix/` — wraps `logs/openclaw_errors.md` checklist |
| Finance review routine | ✅ Done | `.claude/skills/finance-review/` — flags if month's budget missing |
| Charybdis check-in routine | ✅ Done | `.claude/skills/charybdis-checkin/` — prompts to log new evidence |
| Market research routine | ✅ Done | `.claude/skills/market-research/` — anchored to Phase 2B projects |

---

## Open Questions

- [ ] What is the actual D: drive path for the repo? (needed for `workspace` in openclaw.json)
- [x] What messaging channel does Boss prefer for proactive alerts? → Telegram confirmed
- [ ] What is Charybdis for, and how urgent is it? (confirmed: unrelated to Chestnut)
- [ ] Is there a specific income target or timeline for Forge Fire?
- [ ] Does Boss want me to search for jobs actively, or is Forge Fire the only path?
- [ ] Riverside.fm — is this for content creation / WhisperBOT integration, or personal?
- [ ] Facebook security alert (Jun 5) — was that login near St. Louis yours?

---

## Notes

- All Forge Fire active tasks live in ClickUp space `90173686954`
- Previous task system was Zenflow — migrated to ClickUp (tasks reference both)
- Sinter agent already has wake/sleep skills built (task `86e1gw755` marked complete)
