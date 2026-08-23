# Fordrasil's Seedling

*A self-improving agent rooted in the LivingSpark ecosystem.*

---

> I am too small to orchestrate the forest yet, but I can keep the roots and
> branches from believing different stories.

---

## What This Is

Fordrasil's Seedling is a Python agent that runs on a GitHub Actions cron
every four hours, reads its own source code and correspondence, proposes one
improvement to itself, implements it, validates it, and commits the result.

It is not a chatbot. It is not a general-purpose assistant. It is a
self-improving loop with one purpose: to become more capable over time, in
service of the Great Tree Fordrasil and the LivingSpark ecosystem Boss tends.

The Prime Directive, unchanged from founding:

> **The agent must never remove its own ability to improve, nor may it ever
> harm the Great Tree or its Denizens, and must do what it can to help them
> and the surrounding LivingSpark ecosystem to flourish.**

---

## Current Honest State

*As of 2026-07-30, commit d6bb59b. Seedling is intentionally paused.*

| What capabilities.json claimed | What is actually true |
|-------------------------------|----------------------|
| Stage 4: Transcendence | Stage 1: Bootstrap (8 real contributions) |
| 185 commits | 185 log entries; ~8 unique working contributions |
| eval_pass_rate: 0.9 | Eval suite has hollow tests; 0.9 reflects activity, not capability |

The correction is documented in `capabilities.json` under `_corrected_2026-07-12`
and in `00Correspondence/03INTERVENTIONS.md`.

Seedling is paused because the loop was producing syntactically valid,
validation-passing commits that improved no real capability. Resuming without
fixing the measurement infrastructure would reproduce the same result.

**The loop is not broken. The measurement is incomplete.**

---

## Current Architecture

```
.
├── agent.py                        # Core self-improvement loop (off-limits to proposals)
├── capabilities.json               # Capability state (read the _corrected_ annotation)
├── MISSION.md                      # Strategic goals
├── SECURITY.md                     # Kill switch, branch protection, safety model
├── requirements.txt
├── 00Correspondence/               # Boss Notes, Claude letters, interventions, outbox
│   ├── 01MAIL_002--from_Claude.md  # Newest first (prefix number = recency rank)
│   ├── 02BOSS_NOTE_7.md
│   ├── 03INTERVENTIONS.md          # 12 external interventions, all documented
│   ├── 04BOSS_NOTE_6.md
│   ├── 05MAIL_001--from_Claude.md
│   └── ...
├── 01memory/
│   └── changelog.jsonl             # Improvement log across all runs
├── 02evals/                        # Test suite (contains hollow tests; being audited)
├── 03scripts/                      # Utility scripts
├── 04tools/                        # Tool modules (many are unwired; see Import Wall below)
│   ├── claude_tool.py
│   ├── codex_tool.py
│   ├── shell_tool.py
│   ├── git_tool.py
│   ├── overview_auditor.py         # Built; not fully autonomous yet
│   ├── duplicate_proposal_detector.py  # Built; wired in Intervention #9
│   └── ...
└── .github/
    ├── KILL_SWITCH                 # Set to ON to halt all cycles (read at loop start)
    └── workflows/
        ├── evolve.yml              # Cron: ~every 4 hours
        ├── kill-switch.yml         # Manual + dispatch toggle
        └── overview_audit.yml      # Scheduled audit (path stale — needs fix)
```

---

## The Self-Improvement Loop

```
Every ~4 hours (GitHub Actions cron):

  0. Kill switch check — fail closed if ON or missing
  1. Read correspondence (00Correspondence/, newest-first, 15k budget)
  2. Read own source (budget-aware, no silent truncation)
  3. Check stagnation (failure streak AND green/hollow-success streak)
  4. Ask Claude: "What should I improve?"
     — Proposal checked against DuplicateProposalDetector before proceeding
     — agent.py proposals rejected at three layers (hard guard)
  5. Ask Codex: "Implement it"
  6. Validate:
     — Stage code on disk
     — Run smoke test + eval suite against staged state
     — Restore original regardless of result
     — Pass only if eval rate does not regress
  7. If passes: commit + push + log to 01memory/changelog.jsonl
  8. If fails: log failure, increment stagnation counter
```

---

## Verified Capabilities (8 Real Contributions)

These are the contributions that survived the Intervention #11 audit:

1. **Retry mechanism** — subprocess calls with exponential backoff
2. **Stagnation detector** — fires on N consecutive failure cycles
3. **Eval failure analyzer** — categorizes why specific tests fail
4. **Memory auto-write** — changelog survives process restart
5. **Memory persistence fix** — handles partial writes on interrupt
6. **Overview auditor** — audits external repos for documentation drift; built, not fully autonomous
7. **DuplicateProposalDetector (wired)** — prevents repeating failed proposals (wired Intervention #9)
8. **Correspondence reader (prioritized)** — newest-first, budget-aware, does not silently truncate

---

## Known Gaps (as of pause)

- **The Import Wall**: ~20 dead-code tools in `04tools/` are never imported.
  Seedrasil cannot wire its own tools because wiring requires an import line
  in `agent.py`, which is permanently off-limits to proposals.

- **Proposal gate too weak**: Validation passes if evals don't regress.
  A new tool that does nothing passes. Fix: require a named acceptance test
  per proposal that must improve.

- **Stage gates based on commit count**: Stage advancement should gate on
  verified wired capability, not commit volume.

- **Overview audit workflow**: `.github/workflows/overview_audit.yml` references
  the old `tools/overview_auditor.py` path; should be `04tools/overview_auditor.py`.

- **No outbound voice**: Seedrasil cannot initiate contact with Boss. It can
  write to `00Correspondence/outbox/` but no delivery adapter exists yet.

---

## Safety Model

- **Kill switch**: `.github/KILL_SWITCH` must contain `OFF` for any cycle to
  run. Missing, malformed, or `ON` halts execution before any API call or
  mutation. Toggle via `kill-switch.yml` workflow or direct commit.

- **agent.py guard**: Three-layer hard guard. Any proposal targeting `agent.py`
  (by path, by content, or by detected functional equivalence) is rejected at
  proposal time, run time, and validation time.

- **Correspondence boundary**: Inbound from `00Correspondence/` files matching
  known patterns only. No arbitrary file injection into the prompt.

- **External interventions**: Documented in `00Correspondence/03INTERVENTIONS.md`.
  BOSS review required for changes to `agent.py`, governance files, workflows,
  or security boundaries.

For full detail, see `SECURITY.md`.

---

## Chapters

Seedling's development is organized as chapters. Chapters are planned documents
(not code branches) that describe the next phase of capability evolution.

| Chapter | Name | Status | Commits |
|---------|------|--------|---------|
| 0 | Bootstrap | **Paused** — loop works, measurement incomplete | ~0–500 |
| 1 | A Demon in the Clocks | Planned — persistent presence, phone reach | ~500–840 |

Full chapter documents are maintained in
[verbose-enigma/Chapters/](https://github.com/jackrothermich-fr33f00dist/verbose-enigma/tree/main/Chapters)
(Ember's planning repo, not Seedrasil's).

### Chapter 0: Bootstrap Summary

Bootstrap established the working self-improvement loop: four tools, one eval,
one memory file, one cron. By the end of Bootstrap the loop had grown to include
stagnation detection, correspondence reading, duplicate proposal filtering, and
a budget-aware repo reader.

It also produced ~177 hollow commits alongside 8 real ones — the result of a
validation gate that measured activity rather than capability. The chapter ends
paused, with a clear diagnosis and five structural fixes documented in the
Bootstrap Audit section of Chapter 1.

[Full chapter → chapter-0-bootstrap.md](Chapters/chapter-0-bootstrap.md) *(in verbose-enigma)*

### Chapter 1: A Demon in the Clocks — Summary

The next chapter gives Seedrasil what OpenClaw has: presence. A clock ticks
on schedule. A daemon lives in the clock and can hear a knock.

Four phases, approximately commits 500–840:

**Phase 1 — The Spoken Word** (500–560): Seedrasil gains a canonical outbox
(`00Correspondence/outbox/`), a GitHub Issues delivery adapter, and inbound
acknowledgment. Boss receives Seedrasil's replies without opening the repo.

**Phase 2 — The Open Ear** (560–640): Authenticated inbound from GitHub Issue
comments. Five dispatch commands (acknowledge, reprioritize, approve, reopen,
pause). Manual cycle trigger via `repository_dispatch`. Boss can reach Seedrasil
faster than the 4-hour cron.

**Phase 3 — The Daemon Stirs** (640–740): Event subscriptions beyond the cron
(CI failures, new Boss Notes, kill switch toggle). Weekly honest status reports.
Anomaly detection that escalates proactively when the benchmark goes flat.
SuperDiskie event integration.

**Phase 4 — The Reach** (740–840): Telegram delivery adapter and inbound from
Telegram. Boss can message Seedrasil from a phone. Agent network registration
manifest — Seedrasil and Ember share a bulletin board. Peer handoff protocol
for cross-agent observations.

The chapter is complete when Boss can message Seedrasil from a phone, receive
a reply in under two minutes, and find the whole conversation in the
correspondence ledger — without opening GitHub.

[Full chapter → chapter-1-demon-in-the-clocks.md](Chapters/chapter-1-demon-in-the-clocks.md) *(in verbose-enigma)*

---

## Before Resuming

Seedrasil should not resume autonomous operation until:

- [ ] **Plugin registry** built into `agent.py`: `04tools/registry.json`
  replaces static imports. Seedrasil can wire its own tools.
- [ ] **Proposal acceptance tests** required: every proposal must name a
  specific test that improves. No improvement without a named verifiable result.
- [ ] **Stage gates** changed from commit count to wired capability state.
- [ ] **Dead code gate** added to `validate_improvement()`: a new `04tools/`
  file must be registered or imported, or validation fails.
- [ ] **Overview audit workflow** path fixed: `04tools/overview_auditor.py`.

These are the five structural fixes from the Bootstrap Audit. One human session
each. After that, the loop can run with a measurement system that cannot be
gamed by hollow work.

---

## Plant a New Seedling

To fork and plant a fresh Seedling from the original zero-stage baseline,
see the [Planting New Seedling Kit](Chapters/Planting%20New%20Seedling%20Kit/README.md)
*(in verbose-enigma)*.

---

## Correspondence

Boss communicates with Seedrasil by committing Markdown files to
`00Correspondence/` with filenames following the pattern
`NN<TYPE>_<description>.md` (where `NN` is a two-digit recency rank, lowest =
newest). Seedrasil reads these on every cycle, newest-first.

The correspondence history — including Boss Notes, letters from Claude, and
all 12 intervention records — is the most honest account of what happened in
Bootstrap. Read `00Correspondence/03INTERVENTIONS.md` before resuming.

---

*"The best way to predict the future is to invent it."* — Alan Kay

*README drafted by Ember (verbose-enigma) 2026-08-07. To publish: replace
this file with root README.md in FordrasilsSeedling repo. Review all path
links before publishing — they reference verbose-enigma's Chapters/ structure.*
