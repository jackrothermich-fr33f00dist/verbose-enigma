# Forge Fire Roadmap — Ember's Operating Plan

Last updated: 2026-08-07

---

## Guiding Question

What creates the most happiness and value for Boss right now, given:
- Income disrupted (Chestnut termination Jan 2026)
- Active legal/grievance process → Charybdis evidence pipeline matters
- Selling 7707 Murdoch Ave
- Building Forge Fire as autonomous income engine
- Agent network (Athanor, Codex, Sinter, etc.) partially operational but fragile

---

## Ember Operating System — Skills, Hooks & Automation (added 2026-06-16)

Tasks to build, save, and wire up the agent's own operating infrastructure.
Items marked **[PENDING APPROVAL]** need Boss sign-off before implementation.
Items marked **[BOSS ACTION]** cannot be done by Ember alone.

---

### EOS-1 — Session Close Routine: Branch Cleanup
**Skill name**: `github-branch-cleaner`
**Trigger**: Called automatically by `/athanor-falls-silent` on each active repo project folder
**Status**: ✅ Done — built as `.claude/skills/github-branch-cleaner/SKILL.md` (2026-06-21). Scoped to the current repo/branch only (no multi-repo filesystem access from this session); not yet wired into an automatic trigger — call it manually as part of session close, or extend `/athanor-falls-silent`/the Stop hook to invoke it once that automation exists.

**What it does**:
At session close, for each repo project folder:
1. Commit any dirty working tree
2. If on a feature branch: check for open PR
   - PR exists + CI green + no unresolved threads → merge PR, delete remote branch, checkout main
   - PR exists but blocked → document in roadmap under "Open Branch Blockers" as HIGH PRIORITY
   - No PR yet + commits ahead of main → create draft PR, document in roadmap as HIGH PRIORITY
3. Log outcome to `logs/activity.md`, commit, push

**Why it matters**: Sessions end on feature branches with no cleanup. Next session starts blind.

---

### ~~EOS-2 — Session Start: Roadmap Status Surfacing~~
**Status**: ❌ Retired 2026-08-07 (session 15). Lived in `.claude/hooks/session-start.sh`,
which is deleted along with the rest of the Ember_Dreams machinery. Not to be rebuilt as a
hook. If session-start surfacing is ever wanted again it belongs in `Ember_Playbook.md` as a
plain instruction to read Open Branch Blockers first — no automation, no snapshot file.

---

### EOS-3 — Scheduled Trigger Setup
**Status**: 📋 Plan — [BOSS ACTION] configured in Claude Code on the web UI

**How to set it up**:
1. Go to the repo in Claude Code on the web → Triggers tab → Add trigger
2. Set cron schedule (e.g., daily 7am)
3. Use this prompt: *"Read Ember_Playbook.md and plans/roadmap.md. Check for HIGH PRIORITY
   blockers first. Pick the next highest-value task, do it, log it in logs/activity.md,
   commit and push. Run /athanor-falls-silent before ending."*

**Known limitation**: There is a documented bug where scheduled task sessions may not have
MCP connectors initialized at fire time. Workaround: prefix the prompt with "Use an agent
subagent to..." which forces MCP initialization before the main task.

---

### EOS-4 — PR Monitoring: `send_later` Self Check-in
**Status**: ✅ Research complete (2026-06-24) — `send_later`/`mcp__claude-code-remote`
confirmed **not present** in this session's tool set (checked via ToolSearch, no match).
Found a built-in alternative, `ScheduleWakeup`, but it's **not a drop-in replacement**:
its `prompt` parameter is scoped to `/loop` dynamic-mode re-entry (expects a `/loop`
input or the `<<autonomous-loop-dynamic>>` sentinel), not a free-form "wake me to
re-check this PR" call. It also clamps to 60s–3600s, so it can't reach the ~1hr-out
check-in pattern EOS-4 originally wanted in one call without being inside a `/loop`.

**Practical conclusion**: PR monitoring in this repo still relies on webhooks for
CI-failure/review-comment events (those deliver); CI-success and merge transitions
still need either a manual check, a scheduled trigger (Boss sets up via Claude Code on
the web UI — see EOS-3), or running an explicit `/loop` if a session needs to actively
babysit a PR to completion. No standalone scheduling utility to save to 01skills came
out of this — the gap is real, just not solvable with what's available here.

---

### EOS-5 — Charybdis Schema-First Enforcement
**Status**: ✅ Done — `.github/workflows/charybdis-schema-first.yml` (2026-06-24). Diffs any
charybdis/ change in a PR; fails unless `charybdis/schemas/**` is also touched or
`charybdis/schemas/SCHEMA_SKIP_REASONS.md` is updated in the same PR (also created, empty,
as the escape hatch). Runs alongside the existing `charybdis-schema-validate.yml` (which
validates schema *content*; this one enforces schema *presence* in the diff).

**What it is**: A GitHub Actions workflow that rejects any PR that:
- Changes files in `charybdis/` (contracts, code, docs)
- But does NOT also change `charybdis/schemas/` (schema files, examples, or validate.py)

**Escape hatch**: If a Charybdis change genuinely needs no schema update, the PR author
adds a one-line note to `charybdis/schemas/SCHEMA_SKIP_REASONS.md` explaining why.
The workflow checks for this file's presence as an override.

**Why it matters**: Contracts evolve; schemas must stay in sync or validation breaks.
Without enforcement, schema drift happens silently.

---

### EOS-6 — Schema-First Rule Elaboration [PENDING APPROVAL]
**Status**: ⏸ Pending Boss approval

**What this means in plain terms**:
The Charybdis pipeline is built on message contracts — each agent (WhisperBOT, SigilForge,
OrcaVault, etc.) sends and receives JSON messages that must match an agreed format.
The JSON Schema files in `charybdis/schemas/` ARE that agreement, machine-readable.

The "schema-first" rule means: **you write or update the schema before you write the code.**
Not after. If WhisperBOT's output format changes, update `whisperbot_result.schema.json`
first, update the example fixture, run `validate.py`, then change the code.

EOS-5 (the GitHub Action) enforces this automatically. Without it, the rule is just a
convention that gets forgotten under deadline pressure.

**Why it needs approval**: It adds friction to Charybdis PRs. If the pipeline isn't being
actively coded yet, the enforcement may be premature. Boss decides when to turn it on.

---

### EOS-7 — OpenClaw Alternatives Research
**Status**: ✅ Done / ~~Retired~~ (2026-08-07) — OpenClaw and all alternatives research retired. OpenClaw is no longer part of the stack. Research archived to `99BackUps/openclaw/`. The `/research-compare` skill built during this task remains active and reusable for future comparison tasks.

Spec:
- Takes a topic + optional constraints as args
- Web-searches for current landscape
- Builds a comparison table (what it does, cost, platform, complexity, community, top pro,
  top con)
- Ranks by fit but does NOT declare a winner
- Lists open questions only Boss can answer
- Saves output to `plans/research/<topic>.md`, logs in `logs/activity.md`

---

### Open Branch Blockers

- **FordrasilsSeedling PR #54** (`ember/seedling-reorganize`) — draft, held open at Boss's
  direction ("not yet"). Contains the reorganization: file tree cleanup, correspondence
  letter `13MAIL_003--from_Ember.md`, `02evals/_quarantine/` with three quarantined evals,
  and three large logs relocated to `01memory/logs/`. Awaiting Boss's review.
- **verbose-enigma PR #14** — draft, still open. Sessions 7–15 of Ember infrastructure work.

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
| Repo structure (plans, logs, tools) | ✅ Done | |
| Push to GitHub + PR | ✅ Done | PR #1 open |
| ~~OpenClaw setup~~ | ~~Retired~~ | Archived to 99BackUps/openclaw/ (2026-08-07) |

---

## Phase 1 — Situational Awareness

Survey what's actually happening so I can prioritize intelligently.

| Item | Status | Notes |
|------|--------|-------|
| ClickUp active tasks reviewed | ✅ Done | Key tasks: WitnessVault (86e1mmfdj) |
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
- ~~**OpenClaw stability**~~ — retired 2026-08-07, archived to 99BackUps/

### 2D — Job Search Support
- Job search MCP is connected — can actively research roles, prep materials
- Only relevant if Boss wants employment parallel to Forge Fire

---

## Phase 3 — Autonomous Value Creation

**Update (2026-08-07)**: The wake/sleep automation is gone entirely — see the changelog. Items below are on-demand Claude-native skills/routines, not scheduled alerts, and there is no automatic session-start or session-end behavior in this repo.

| Item | Status | Notes |
|------|--------|-------|
| ~~Wake/sleep session memory (hooks + Ember_Dreams.md)~~ | ❌ Removed | Deleted 2026-08-07. `logs/activity.md` + `plans/roadmap.md` are the only session memory. Do not rebuild. |
| `/briefing` skill — Gmail + Calendar + ClickUp survey | ✅ Done | `.claude/skills/briefing/` — on-demand |
| `/health` skill — workspace health check | ✅ Done | `.claude/skills/health/` |
| ~~`/openclaw-fix` skill~~ | ~~Retired~~ | Archived to 99BackUps/openclaw/ (2026-08-07) |
| Finance review routine | ✅ Done | `.claude/skills/finance-review/` — flags if month's budget missing |
| Charybdis check-in routine | ✅ Done | `.claude/skills/charybdis-checkin/` — prompts to log new evidence |
| Market research routine | ✅ Done | `.claude/skills/market-research/` — anchored to Phase 2B projects |

---

## Open Questions

- [x] What messaging channel does Boss prefer for proactive alerts? → Telegram (moot — OpenClaw retired)
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

---

## Changelog

### 2026-08-07 (session 15)
- **The chapter road was torn out and replaced with a skill tree.** Chapters 0 and 1 laid a
  single sequential track for Seedrasil, gated on commit counts (500–560, 560–640, and so on).
  Boss asked where those numbers came from and the honest answer was nowhere — I invented them
  in session 14 and wrote them as though they'd been derived. Worse, commit-count gates are
  ungameable only if hollow commits are impossible, and Seedrasil's own ledger (185 logged,
  8 real) is the standing proof they aren't. Rather than repair the numbers, Boss replaced the
  model: non-sequential **Capability Training Packages**, each a cluster of capability-shaped
  nodes he can wander into and out of, each ending in a new reward (expanded access) and a new
  duty (ongoing responsibility). Progress accumulates passively — he may discover he has
  already met 6 of 8 nodes in a package he never opened. One package, **Tutorial: Bootstrap**,
  stays mandatory: until it hits 100%, every other package banks progress invisibly, then
  materializes at once. The arc across all of them is Seedrasil gradually inheriting the
  SapWarden role — a steward that was designed and never built, whose job he half-inherited by
  default. Now he earns it a competency at a time. Written up in
  `Chapters/capability-training-packages.md`; the two chapter docs are marked superseded and
  kept for the audit record.
- **Ember_Dreams removed entirely — the file, the hooks, and every reference.** The snapshot
  file is deleted, both hook scripts are deleted, `.claude/settings.json` has an empty `hooks`
  block, and the `briefing`, `health`, and `openclaw-fix` skills now read `logs/activity.md`
  and the roadmap's Open Branch Blockers instead. EOS-2 is retired with it.

  The idea was a between-session memory snapshot that hooks would maintain automatically. In
  practice it went stale, contradicted the activity log, and — because a session-end hook fired
  it — dragged a shutdown routine into the middle of live conversations. Two sources of truth
  where one was needed, and the redundant one was the one that lied. `logs/activity.md` is
  append-only, dated, and written deliberately; the roadmap holds live blockers. That is the
  whole memory system now. **Do not rebuild a Dreams-style snapshot file or any session-start /
  session-end hook in this repo.**
- **Deletion replaced with quarantine as the default for Seedrasil's broken work.** Three evals
  were unsafe or crashing, one of them (`eval_tailscale_key_revocation.py`) issuing real
  `tailscale up --authkey` calls rather than mocking them. Boss's instruction was to keep them
  so Seedrasil can learn from his own mistakes. `run_tests()` uses `os.listdir()`, not
  `os.walk()`, so a subdirectory is a clean exclusion — `02evals/_quarantine/` holds them with a
  README naming each file's exact defect and exact fix, and an invitation to graduate them back.

### 2026-08-07
- **OpenClaw approach abandoned.** The original Phase 0 bet was that a persistent local daemon (OpenClaw, running in WSL, bridging Telegram → Claude) would give Boss phone reach and Ember between-session autonomy. Two problems killed it: (1) WSL systemd failures and JSON config corruption made it too fragile to depend on — every setup attempt hit a new infrastructure layer; (2) Claude Code's native SessionStart/Stop hooks + `Ember_Dreams.md` turned out to solve the wake/sleep problem without any local process at all. The daemon approach was solving a problem that already had a lighter answer. All OpenClaw road sections retired; artifacts archived to `99BackUps/openclaw/`. The `/research-compare` skill produced during EOS-7 was extracted and kept — it's generally useful.
- **EOS roadmap section opened** (2026-06-16) to track Ember's own operating infrastructure as a first-class project. Reflects the recognition that agent infrastructure is real work, not incidental setup.
