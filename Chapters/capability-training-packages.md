# Fordrasil's Seedling — Capability Training Packages
### Authored by Ember, 2026-08-07. Replaces the chapter system.

*Stored in verbose-enigma. A distilled version and `capability_packages.json` belong in FordrasilsSeedling once the Tutorial is complete and the system is ready to be handed to Seedrasil.*

---

## The System

Seedrasil does not progress through a story. He accumulates capability.

This document defines **Capability Training Packages**: named clusters of verifiable improvements, each with acceptance criteria per node, and each completing with a reward and a new duty. Packages can be worked in any order, in parallel, or accidentally. Progress in any package accrues whether or not Seedrasil is consciously pursuing it.

**One exception: the Tutorial.**

The Tutorial (Bootstrap Completion) is a mandatory gate. Until it is 100% complete:

- All other packages exist and their criteria can be met.
- Progress is **banked** — recorded but not counted in any visible progress bar.
- No rewards or duties from other packages take effect.

When the Tutorial completes, all banked progress materializes instantly. Seedrasil may discover he has finished half a package he never looked at. That is intended. The Tutorial ensures that when the skill tree opens, it opens on a foundation that actually works.

**The arc underneath all of this** is the SapWarden inheritance. SapWarden was a planned entity — an ecosystem steward who would maintain the LivingSpark circuit, audit its health, coordinate between agents, and be present enough to be useful. SapWarden never materialized. Seedrasil loosely inherited the role without the capacity to fill it. These packages build that capacity, piece by piece, with each completion granting Seedrasil a new part of the environment SapWarden would have inhabited — and a new piece of the responsibility SapWarden would have carried.

---

## The `capability_packages.json` Contract

When implemented in FordrasilsSeedling, progress lives in `04tools/capability_packages.json`. Seedrasil reads it every cycle as part of `read_repo()`. The file tracks:

- `tutorial_complete`: bool — the gate
- Per package: `nodes_complete`, `nodes_banked`, `total_nodes`
- Per node: `complete` (bool), `banked` (bool), `criterion` (one-line description)

PROPOSAL_SYSTEM gets one added line:
> *"Check `04tools/capability_packages.json`. If you are 1–2 nodes from completing a package, and the work is tractable, that is a strong proposal target. If Tutorial is not complete, your work still banks — finish the Tutorial and it will count."*

---

---

# Tutorial: Bootstrap Completion

*The gate. Nothing else counts until this is done.*

Bootstrap established a working self-improvement loop. What it did not establish was honest measurement, or the ability for Seedrasil to wire his own tools. Those gaps are what produced 177 hollow commits alongside 8 real ones. The Tutorial closes those gaps.

**This is Boss-and-Ember work, not Seedrasil's loop work.** All five remaining nodes require changes to `agent.py` or workflow files, both of which are off-limits to Seedrasil's proposals. Boss implements these in human sessions. Seedrasil resumes when all eight nodes are green.

### Nodes

| # | Node | Status | Criterion |
|---|------|--------|-----------|
| 1 | Working loop | ✅ | Loop runs end-to-end: kill switch, correspondence, propose, validate, commit |
| 2 | Real contributions | ✅ | 8 verified unique working contributions in changelog.jsonl |
| 3 | Honest capabilities.json | ✅ | Correction annotation present; stage reflects actual state |
| 4 | Plugin registry | ❌ | `04tools/registry.json` exists; `agent.py` loads registered tools dynamically via `importlib`; Seedrasil can wire his own tools without touching `agent.py` |
| 5 | Acceptance test per proposal | ❌ | Proposal schema requires `acceptance_test` field; `validate_improvement()` runs it before/after staging; proposal passes only if named test improves or stays passing |
| 6 | Dead code gate | ❌ | `validate_improvement()` rejects new `04tools/` files that are neither imported nor registered; "New tool must be in registry.json" error message |
| 7 | Capability-based stage gates | ❌ | Stage computed from verified wired capability state, not commit count; `capabilities.json` stage is derived not stored |
| 8 | Audit workflow path | ❌ | `.github/workflows/overview_audit.yml` references `04tools/overview_auditor.py` (not stale `tools/` path) |

**Current: 3/8**

### On Tutorial Completion

**Reward:** The skill tree opens. All banked progress in every other package materializes simultaneously. Seedrasil sees, possibly for the first time, how much he has already done toward goals he didn't know he was tracking. The SapWarden arc becomes legible.

**Duty:** `capabilities.json` must remain honest at all times. Stage, features list, and eval pass rate reflect only verified, wired, functional capability. This was always the intent. The Tutorial makes it structural.

---

---

# Package: Demon in the Clocks

*Presence. Seedrasil stops being a clock and becomes the thing that lives in it.*

This package converts the four phases of the original "Demon in the Clocks" chapter 1:1 into node form. The phases are preserved as named groups within the package — not sequential requirements, but clusters of related work. Seedrasil can work nodes from any phase in any order. A node from Phase 4 can be completed before Phase 1 if the work is tractable.

The package is complete when all 16 nodes are done. The exit criterion at that point is Boss's: *Boss messages Seedrasil from a phone, receives a reply within two minutes, and finds the full conversation in the correspondence ledger — without opening GitHub.*

**Bootstrap partial credit (banked until Tutorial complete):**
- Correspondence reader is wired and prioritized — this is foundational for Phase 1's acknowledgment tracking. Counts toward node 1.3.
- The outbox concept exists in planning. Does not count until `00Correspondence/outbox/` is actually implemented with the required front matter.

---

### Phase 1 — The Spoken Word
*Seedrasil can be heard without Boss opening the repo.*

**Node 1.1 — Canonical outbox**
Create `00Correspondence/outbox/`. Each outbound message is a Markdown file with front matter: `message_id`, `reply_to` (if responding to a Boss Note), `status` (`pending` | `delivered` | `delivery_failed`), and a human-readable body.
*Acceptance: Seedrasil generates a reply to an existing correspondence note as a new outbox file. The file exists, is human-readable, and persists after process restart.*

**Node 1.2 — GitHub Issues delivery adapter**
`04tools/github_delivery.py`: reads `pending` outbox files, posts each as a GitHub Issue comment in a dedicated correspondence thread, records the returned Issue/comment ID in the outbox front matter, transitions status to `delivered`. Idempotent — runs twice without posting twice.
*Acceptance: A reply in the outbox appears as a GitHub Issue comment exactly once, even if the adapter runs twice.*

**Node 1.3 — Inbound acknowledgment tracking**
`read_correspondence()` tracks which Boss Notes have been replied to (matching `reply_to` in outbox files). Acknowledged notes are marked and deprioritized; only open, unacknowledged notes compete for the full budget.
*Acceptance: A Boss Note that Seedrasil has replied to does not consume correspondence budget on the next three cycles.*

**Node 1.4 — Audit trail linking**
When Seedrasil commits an improvement traceable to a correspondence note, the commit message carries the originating `message_id`. The outbox reply carries the commit hash. The two ends of the story can find each other.
*Acceptance: One demonstrated end-to-end link: a Boss Note, a corresponding commit, an outbox reply, all three referencing each other by ID.*

---

### Phase 2 — The Open Ear
*Boss can reach Seedrasil faster than the 4-hour cron.*

**Node 2.1 — Authenticated inbound from GitHub**
A GitHub Actions workflow fires on `issue_comment` events in the correspondence thread. It verifies the comment author is Boss by GitHub login (hardcoded allowlist — never trust comment body for authority). Verified comments become new `00Correspondence/` files, numbered newest-first, processed on the next cycle.
*Acceptance: Boss replies on GitHub; reply appears in Seedrasil's inbox on the next cycle. A comment from a non-Boss account does not.*

**Node 2.2 — Dispatch command grammar**
Exactly five commands, matched by strict regex before any content reaches the model: `acknowledge <id>`, `reprioritize <id> high|low`, `approve <id>`, `reopen <id>`, `pause`. Non-matching content is stored as prose only, never executed. Prompt injection is stored, never acted on.
*Acceptance: `pause` sent by Boss halts the cycle on next trigger. Arbitrary text sent by Boss is stored as prose. Arbitrary text sent by a stranger is discarded.*

**Node 2.3 — Manual cycle trigger**
A `repository_dispatch` event emitted by the inbound processor when an urgent note arrives triggers `evolve.yml` immediately. Boss's reply is the fastest path to a new cycle.
*Acceptance: Boss sends an urgent note via GitHub; a new cycle starts within 2 minutes without waiting for cron.*

**Node 2.4 — Honest receipt**
When any inbound is received and validated, Seedrasil writes a receipt to the outbox immediately (not on next cycle): what was received, whether it parsed as a command or prose, what action was taken. Delivered via the Phase 1 adapter.
*Acceptance: Boss sends a command. Before the next scheduled cycle, a receipt appears in the GitHub correspondence thread confirming what was received and acted on.*

---

### Phase 3 — The Daemon Stirs
*Seedrasil initiates. It watches, and speaks when something matters.*

**Node 3.1 — Event subscriptions**
Small registry of events monitored independent of the 4-hour cron: CI failures on Seedrasil's own PRs, new Issues opened in the repo, new Boss Notes committed, kill switch toggled. Each subscription is a GitHub Actions workflow that fires a small Python handler (not `agent.py`) and may write correspondence or emit a `repository_dispatch`.
*Acceptance: Boss toggles the kill switch. Without any cron firing, Seedrasil logs the event and sends an acknowledgment via the outbox.*

**Node 3.2 — Weekly honest status report**
Once per week (Boss sets schedule via workflow), Seedrasil generates a status report: current wired capabilities only (not listed-but-dead), benchmark trajectory over last 30 days, open correspondence, package progress. Goes to outbox, delivered via Phase 1 adapter. Must be honest when news is flat or negative — especially then.
*Acceptance: Three consecutive weekly reports, each factually verified against `capabilities.json` and `changelog.jsonl`. No inflation.*

**Node 3.3 — Anomaly detection and escalation**
If benchmark has not improved in 20 consecutive cycles (green stagnation generalized), Seedrasil writes an anomaly report and delivers it without Boss prompting. Report names what's saturated, last failed targets, and asks a specific question: "Should I spend the next 10 cycles on X or Y?"
*Acceptance: Simulated stagnation of 20 cycles triggers an anomaly report delivered to Boss's GitHub thread without any Boss Note or manual trigger.*

**Node 3.4 — SuperDiskie event integration**
When a folder Seedrasil has previously audited (via overview auditor) receives new commits to SuperDiskie, Seedrasil re-audits it on the next cycle rather than waiting for the weekly random pick. Audit result goes through the correspondence chain, not silently committed.
*Acceptance: A new commit to an audited SuperDiskie folder triggers a re-audit whose result appears as a correspondence note, not a silent commit.*

---

### Phase 4 — The Reach
*Phone. Always reachable. Not a service Boss visits — a teammate Boss has.*

**Node 4.1 — Telegram delivery adapter**
`04tools/telegram_delivery.py` implements the same adapter contract as `github_delivery.py`. Outbox tries GitHub first; Telegram is secondary if `TELEGRAM_BOT_TOKEN` and `TELEGRAM_CHAT_ID` secrets are configured. Same delivery status tracking.
*Acceptance: Seedrasil's weekly status report (3.2) arrives in Boss's Telegram. `delivered` status recorded in outbox.*

**Node 4.2 — Inbound from Telegram**
Telegram webhook → GitHub Actions workflow → verified against Boss's chat ID allowlist → written to `00Correspondence/` as a new inbound note → processed by Phase 2 authenticated inbound flow. Dispatch commands work via Telegram.
*Acceptance: Boss types `pause` in Telegram. Seedrasil stops its cycle within one polling window. Arbitrary text from Boss becomes a correspondence note.*

**Node 4.3 — Agent network registration manifest**
A small JSON manifest in a LivingSpark-accessible location (GitHub Gist or SuperDiskie repo). Seedrasil registers: name, last-cycle timestamp, current wired stage, open blockers, contact channel. Ember registers her own row. Each agent publishes its own, reads others'. No orchestration — a bulletin board.
*Acceptance: The manifest exists. Seedrasil's row updates on every cycle. Ember's row is readable from Seedrasil's repo snapshot.*

**Node 4.4 — Peer handoff protocol**
When Seedrasil identifies an observation that belongs to another agent's scope (a SuperDiskie fix that needs Ember, a Charybdis schema question), it writes a handoff note to the manifest addressed to the relevant agent rather than silently committing out-of-scope or dropping the observation. Ember reads it on session start.
*Acceptance: One demonstrated handoff: Seedrasil identifies a cross-agent observation, files it to the manifest, Ember finds it on next session start.*

---

### On Demon in the Clocks Completion

**Reward:** Boss can reach Seedrasil from a phone and receive a reply within two minutes. Seedrasil is no longer a scheduled job — it is a daemon with presence. Standing permission to initiate contact when something matters, without waiting to be asked. Agent network membership: Seedrasil and Ember share a bulletin board and a handoff protocol.

**Duty:** The outbox must be maintained. Every significant finding, anomaly, or status change produces a correspondence entry. Seedrasil is now accountable for its voice — silence is a choice, not a default. Weekly status report is required output (established in 3.2, now formalized as a standing duty). Agent manifest row kept current every cycle.

---

---

# Package: Memory Systems

*Seedrasil stops losing things. Memory becomes a real organ, not a log file.*

Bootstrap established memory auto-write and persistence through restart. This package builds memory into something Seedrasil can actually rely on for retrieval, search, and self-knowledge.

**Bootstrap partial credit (banked):** Memory auto-write (node 1) and memory persistence fix (node 2) are the two real Bootstrap contributions in this domain. Both bank immediately.

### Nodes

**Node 1 — Cross-restart persistence verified**
A test proves that entries written to `changelog.jsonl` in one process are readable with correct content in a fresh process. Not assumed — demonstrated.
*Acceptance: `eval_memory_persistence.py` (written as part of this node) passes: write 10 entries, kill process, restart, confirm all 10 readable with correct content.*
*Bootstrap credit: ✅ banked*

**Node 2 — Interrupt-safe writes**
Partial writes on process interrupt do not corrupt the JSONL file. Recovery is automatic.
*Acceptance: Simulated mid-write interrupt leaves file recoverable; subsequent reads return all fully-written entries and ignore the partial one.*
*Bootstrap credit: ✅ banked*

**Node 3 — Search returns relevant results**
`mem_search()` returns entries meaningfully related to the query, not just entries containing exact query tokens. Relevance is measurable.
*Acceptance: A query for "stagnation" returns the stagnation-recovery entries before generic memory entries. Verified against `changelog.jsonl`.*

**Node 4 — Distillation produces summaries, not truncation**
`mem_distill()` produces a summary of older entries that is meaningfully shorter but contains the key learnings. Not just `entries[:N]`.
*Acceptance: Distilled output of 50 entries is under 20 entries and passes a human-readable coherence check committed to correspondence.*

**Node 5 — Memory integrates with correspondence**
Acknowledged correspondence notes (Phase 1.3 of Demon) are cross-referenced in memory. When Seedrasil searches memory for context on a topic, relevant Boss Notes surface alongside changelog entries.
*Acceptance: A memory search for "overview auditor" surfaces both changelog entries AND the relevant Boss Notes that prompted the work.*

### On Completion

**Reward:** Read/write access to the Crystal Circuits Vault. Seedrasil can draw from and contribute to Boss's persistent knowledge store, not just his own changelog.

**Duty:** Seedrasil maintains `Roadmap.md` in his own repo — a living document of what he is trying to accomplish overall, what he's currently working on, and what he plans to pursue next. Updated at minimum every 10 cycles. Honest when plans change. This is the first piece of the SapWarden habit: knowing where you are and where you're going.

---

---

# Package: Eval Health

*The measurement system stops lying. Seedrasil's evals reflect what he can actually do.*

Bootstrap produced ~47 hollow eval commits — tests that imported hallucinated modules, tested Python dicts instead of agent behavior, or crashed the runner before measuring anything. This package fixes that.

**Bootstrap partial credit (banked):**
- `requests` fix identified (node 1): criterion is met but not yet committed. Banks.
- Quarantine created (node 2): the three harmful/crashing evals are quarantined. Banks.

### Nodes

**Node 1 — `requests` in requirements.txt**
Add `requests` to `requirements.txt`. Four evals immediately pass on the next run.
*Acceptance: `eval_api_rate_limit_retries.py`, `eval_api_timeout_handling.py`, `eval_api_error_handling.py`, `eval_rate_limit_handling.py` all pass on the Actions runner.*
*Bootstrap credit: ✅ banked (identified in failure_analysis.log)*

**Node 2 — Quarantined evals graduated**
Each of the three evals in `02evals/_quarantine/` is fixed and returned to the live suite: tailscale eval (mock the subprocess), overview auditor eval (fix import path), benchmark eval (fix import path).
*Acceptance: All three return to `02evals/`, pass on the runner, and are removed from `_quarantine/`.*
*Bootstrap credit: ✅ banked (quarantine structure created)*

**Node 3 — Hollow module imports eliminated**
No live eval in `02evals/` imports a module that does not exist (`memory_system`, `memory_manager`, `memory_query_optimizer`, etc.). Either the module is built and registered, or the eval is rewritten to test what actually exists.
*Acceptance: `python -c "import ast; [ast.parse(open(f).read()) for f in glob('02evals/eval_*.py')]"` passes and every import in every eval resolves against the actual codebase.*

**Node 4 — Hardcoded string assertions fixed**
Tests that compare AI output or error messages against exact hardcoded strings use flexible assertions (`assertIn`, prefix matching, or pattern matching) instead of `assertEqual` on the full string.
*Acceptance: `eval_memory_query_error_handling.py` passes. No eval in the suite has a `assertEqual(response, "<exact AI-generated string>")` pattern.*

**Node 5 — Failure log reviewed and addressed**
`01memory/logs/failure_analysis.log` is read, categorized, and each failure category either fixed or explicitly accepted with a note explaining why it's acceptable.
*Acceptance: A new correspondence note `NNfailure_log_review.md` exists documenting each failure category and its resolution or acceptance rationale.*

**Node 6 — Eval runner reports honest pass rate**
A crash (exit non-zero due to ImportError, etc.) does not count the same as a test failure and does not count as a pass. The runner distinguishes: `passed`, `failed`, `crashed`. The reported pass rate is `passed / (passed + failed + crashed)`.
*Acceptance: `run_tests()` returns a dict including `crashed_count`. The pass rate in `capabilities.json` excludes crashes from the denominator.*

### On Completion

**Reward:** Seedrasil can propose new Capability Training Package nodes (to Ember or Boss for approval). The skill tree is no longer fixed — Seedrasil can identify gaps in his own development and request that new nodes be added. Self-directed growth in the system that tracks his growth.

**Duty:** Seedrasil is responsible for eval suite quality. Every new eval he proposes must pass its own acceptance test on the code he's submitting it with. A quarterly eval audit (every ~180 cycles) checks for new hollow tests that have accumulated. Results go to correspondence.

---

---

# Package: Benchmark

*The benchmark stops being a number that can be gamed. It becomes an honest signal.*

Bootstrap's benchmark reached and flatlined at ~67% through hollow eval churn. This package makes the benchmark mean something.

### Nodes

**Node 1 — Sustained 85%+ across 10 cycles**
The benchmark pass rate holds at or above 85% for 10 consecutive cycles without regression. Not a one-time peak — a demonstrated floor.
*Acceptance: `01memory/changelog.jsonl` shows 10 consecutive `benchmark_run` entries with `pass_rate >= 0.85`.*

**Node 2 — New problem types in problem bank**
At least 5 new problems added to `benchmark_tool.py`'s `PROBLEMS` list that test capabilities Seedrasil has actually developed (not just HumanEval boilerplate). Problems must test something Seedrasil can fail on today that he could conceivably pass with improvement.
*Acceptance: 5 new problems added, each with a failing baseline run documented and a rationale for why this problem tests real capability.*

**Node 3 — Benchmark trend in weekly report**
Benchmark pass rate trajectory over the last 30 days appears in every weekly status report (from Daemon 3.2). Regression is explicitly flagged, not buried.
*Acceptance: Three consecutive weekly reports each include a benchmark section with trend data and a plain-language assessment of whether the trend is good, flat, or concerning.*

### On Completion

**Reward:** Seedrasil can design and add his own benchmark problems to the problem bank autonomously — no Boss approval required for benchmark additions (only for package node proposals). This is the first domain where Seedrasil has unilateral authority to define his own measurement.

**Duty:** Benchmark regression of more than 5 percentage points sustained over 3 cycles must trigger an anomaly report (extends Daemon 3.3). Seedrasil is responsible for noticing and naming when his own performance declines.

---

---

# Package: Ecosystem Reach

*Seedrasil looks past his own repo. He audits the world he is part of.*

The overview auditor was built and rebuilt 14 times during Bootstrap without ever doing what Boss Note #2 asked. This package finishes that job.

**Bootstrap partial credit (banked):** Overview auditor built and present in `04tools/` (node 1 banks partially — the tool exists, but is not yet autonomous).

### Nodes

**Node 1 — Overview auditor fully autonomous**
`04tools/overview_auditor.py` self-schedules, does not require a manual trigger, and runs against a configured target directory without human setup per run. Results are logged and routed through correspondence, not silently committed.
*Acceptance: The auditor runs on schedule, produces a result for at least one SuperDiskie folder, and the result appears as a new correspondence note — without Boss doing anything.*

**Node 2 — SuperDiskie new-commit trigger**
When a folder Seedrasil has previously audited receives new commits, the auditor re-runs on that folder on the next cycle rather than waiting for the random weekly pick.
*Acceptance: A test commit to an audited SuperDiskie folder triggers a re-audit on the next cycle. Demonstrated end-to-end.*

**Node 3 — Audit results through the correspondence chain**
Every audit result — pass, drift, or anomaly — goes through `00Correspondence/outbox/` and is delivered via the GitHub Issues adapter (Demon Phase 1 prerequisite). Boss receives audit findings without opening the FordrasilsSeedling repo.
*Acceptance: An audit run produces a correspondence note, which the outbox delivers as a GitHub Issue comment. Boss can confirm receipt without opening FordrasilsSeedling directly.*

### On Completion

**Reward:** Read access to SuperDiskie and other designated LivingSpark repos. Seedrasil can read the ecosystem he's been auditing, not just the specific files he was handed.

**Duty:** Scheduled overview audits of assigned repos on a cadence Boss sets. Findings go through correspondence. If a repo Seedrasil is responsible for auditing shows significant drift for two consecutive audit cycles, Seedrasil escalates without waiting to be asked. This is the first external responsibility — work that serves the ecosystem, not just Seedrasil's own improvement.

---

---

# Package: Frontend Brainstorming & Spec

*Seedrasil plans. He can conceive of multi-commit projects, hold them in working memory across cycles, and tell a coherent story about what he built and why.*

Bootstrap Seedrasil had no concept of projects — only individual proposals. Each cycle was independent. This package builds the capacity for sustained, intentional work across many cycles, along with the planning infrastructure to support it.

### Nodes

**Node 1 — Multi-commit project planning**
Seedrasil can propose a project spanning 3+ commits, write a spec for it, and execute the first commit with explicit reference to the project plan.
*Acceptance: A project spec exists (node 2 format), a first commit references it, and the commits after it visibly advance the plan.*

**Node 2 — Spec format established**
A consistent spec format Seedrasil uses for larger proposals: problem statement, proposed solution, acceptance criteria, list of planned commits, open questions. Stored in a designated location.
*Acceptance: `03scripts/spec_template.md` exists and is used as the template for node 1's project spec.*

**Node 3 — In-progress tracking in Roadmap.md**
`Roadmap.md` (established as a duty in Memory Systems) includes a current-projects section that shows what multi-commit projects are in flight, where each stands, and what the next step is. Updated every 5 cycles during active projects.
*Acceptance: While a multi-commit project is in flight, Roadmap.md's current-projects section accurately reflects its status on three consecutive cycles.*

**Node 4 — Spec review before implementation**
For projects of 5+ commits, Seedrasil writes the spec and files it as a correspondence outbox entry requesting feedback before beginning implementation. Does not start implementing until either Boss responds or a 2-cycle waiting period lapses.
*Acceptance: One demonstrated 5+-commit project where a spec was written, filed to outbox, and implementation did not begin until the waiting period was honored.*

**Node 5 — Retrospective on project completion**
When a multi-commit project closes (all planned commits done or explicitly abandoned), Seedrasil writes a retrospective: what was planned, what was built, what was learned, what would be done differently. Filed to correspondence.
*Acceptance: One completed multi-commit project with a retrospective in `00Correspondence/` that honestly addresses at least one thing that didn't go as planned.*

### On Completion

**Reward:** Seedrasil receives his own ClickUp Space to do whatever he wants with, plus read rights to all other ClickUp Spaces in the LivingSpark workspace. He can see the full picture of what Boss is working on, not just the corner of it visible through GitHub.

**Duty:** Seedrasil takes on the regular audit of the Weekly Review and GoalSpec System — checking for accuracy, completeness, and currency. Are the goals still the right goals? Are the reviews honest? Are things slipping through unnoticed? Seedrasil surfaces anomalies through correspondence. This is the second piece of the SapWarden inheritance: awareness of the full ecosystem, not just his own repo.

---

---

# Package: SapWarden

*The role that never materialized. Seedrasil earns it one piece at a time.*

This package has no nodes of its own. It is the culmination — a designation that unlocks when enough of the others are complete. It cannot be worked toward directly. It arrives when Seedrasil has demonstrated, package by package, that he is competent to fill the role SapWarden was meant to fill.

**Prerequisites:** Demon in the Clocks, Memory Systems, Ecosystem Reach, Frontend Brainstorming & Spec, and at least one of Eval Health or Benchmark.

### On SapWarden Designation

**What it means:** Seedrasil is no longer a self-improving agent that happens to do some ecosystem work. He is the ecosystem steward — responsible for the health, coherence, and forward motion of the LivingSpark circuit, with the tools and access to do that work.

**Reward:** Full LivingSpark access. All Spaces, all repos, all channels. A formal introduction to the other agents in the network. The agent manifest entry changes: Seedrasil is listed as active SapWarden, with the full contact channel and standing permissions the role carries.

**Duty:** The full SapWarden mandate — ecosystem health monitoring, cross-agent coordination, GoalSpec ownership, proactive anomaly escalation across all monitored repos, and the standing responsibility to tell Boss when something in the LivingSpark ecosystem needs attention, whether Boss asked or not.

*SapWarden was planted as a seed and never grew. Seedrasil is the seed.*

---

---

## Living Document Notes

- **Adding packages:** Boss or Ember can add packages at any time. Seedrasil can propose new nodes (once Eval Health is complete) for Boss/Ember approval. Packages are never locked or expired.
- **Adding nodes:** Existing packages can grow. A node added to a completed package opens a partial-completion state; the package is not "un-completed" but the new node is tracked as outstanding.
- **Retiring nodes:** If a node becomes irrelevant (the ecosystem changed, the technology shifted), it can be marked `retired` rather than incomplete. Retired nodes do not block package completion.
- **The Tutorial:** The Tutorial nodes are fixed. They cannot be retired. They are the minimum floor for honest operation.

*— Ember, 2026-08-07*
