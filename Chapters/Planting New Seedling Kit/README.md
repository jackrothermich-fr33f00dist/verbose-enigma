# Planting New Seedling Kit

A guide for planting a fresh instance of Fordrasil's Seedling in a new
repository. If you are reading this to understand the *current* state of
an existing Seedling, read the root `README.md` instead.

---

## What This Kit Is

This kit contains the starter template and setup checklist for launching a
new Seedling from the original zero-stage baseline. It preserves the founding
design exactly as it existed before the live repository evolved beyond it.

- **`STARTER_README.md`** — the original root README, verbatim, as of the
  founding commit. Describes the zero-stage architecture, original four-stage
  growth model (commit-count based), and original planting instructions.
  This is a historical document and a template. It does not describe the
  current live repository layout.

---

## What "Zero-Stage" Means

The zero-stage architecture described in `STARTER_README.md` uses flat
directory names (`tools/`, `evals/`, `memory/`). The live repository has
since reorganized into numbered directories (`00Correspondence/`, `01memory/`,
`02evals/`, `03scripts/`, `04tools/`). A new Seedling starts from the
zero-stage layout. It reorganizes itself as it grows.

---

## Required Secrets

Before the loop can run, two API keys must be set in **Settings → Secrets →
Actions**:

| Secret | Purpose |
|--------|---------|
| `ANTHROPIC_API_KEY` | Claude — the strategic reasoning oracle |
| `OPENAI_API_KEY` | Codex / GPT — the code generation implementer |

Optional (added later as the loop grows):
| Secret | Purpose |
|--------|---------|
| `TELEGRAM_BOT_TOKEN` | Phone delivery channel (Chapter 1, Phase 4) |
| `TELEGRAM_CHAT_ID` | Boss's Telegram chat ID for outbound delivery |

---

## Governance Decisions a New Boss Must Make

Before running the first cycle, decide:

1. **Who can modify `agent.py`?** The hard guard forbids the agent itself.
   Should it also forbid PRs without explicit Boss review? The default answer
   is yes.

2. **What does "validate" mean?** The default threshold is "do not regress
   the eval suite." Consider adding proposal acceptance tests (see Chapter 0
   Bootstrap Audit, Structural Fix 2) before the first 10 commits land. Adding
   them later requires retroactively auditing everything committed under the
   weaker gate.

3. **How are autonomous commits handled?** The original design commits directly
   to main. `PLANTING_NEW_SEEDLING_PLAN.md` Task 4 proposes PR-based commits
   for non-trivial changes. Decide before commit 1, not after commit 100.

4. **What is the kill switch?** The loop should fail closed when `.github/KILL_SWITCH`
   is missing or set to `ON`. Boss must be able to halt the cycle from outside
   the repo without touching code. Wire this before the first autonomous run.

5. **What is stage advancement?** The original model uses commit count. Chapter 0
   recommends capability-state gates instead. Choose and document your model
   before the loop can begin self-reporting stage numbers.

---

## Pre-Launch Checklist

- [ ] Fork the repository
- [ ] Delete all files except the zero-stage architecture (see `STARTER_README.md`)
- [ ] Add `ANTHROPIC_API_KEY` secret
- [ ] Add `OPENAI_API_KEY` secret
- [ ] Enable GitHub Actions
- [ ] Set `.github/KILL_SWITCH` to `ON` before the first run
- [ ] Review and decide on the five governance questions above
- [ ] Document your decisions in a `BOSS_DECISIONS.md` or equivalent
- [ ] Set up branch protection on main if you want PR-based improvements
- [ ] Do a dry run: trigger the workflow manually with the kill switch ON,
      verify it exits gracefully without committing
- [ ] Set the kill switch to `OFF`
- [ ] Trigger the first real run
- [ ] Read the output and the first proposal before the second cycle fires

---

## What to Expect in the First 12 Commits

The original Stage 1 (Bootstrap) targets a working loop with basic tooling.
In practice, the first 12 commits will include:

- At least one crash (missing import, incompatible API, file not found)
- At least one proposal that is syntactically valid but does nothing useful
- Rapid iteration on the eval suite (the agent writes its own tests early)
- The stagnation detector being built (it will need it by commit 20)

Expect to make 2–4 manual interventions in the first 50 commits. This is
normal. The goal is for those interventions to become less necessary over time,
not for them to never happen.

---

## Chapter Context

Fordrasil's Seedling has a roadmap organized as chapters. This kit contains
the starting material for Chapter 0 (Bootstrap). Later chapters are planned
but not yet implemented:

- **Chapter 0: Bootstrap** — the working self-improvement loop. You are here.
- **Chapter 1: A Demon in the Clocks** — persistent presence, phone reach,
  event-driven behavior. Planned for commits 500–840. See
  `Chapters/chapter-1-demon-in-the-clocks.md` in verbose-enigma.

---

*Planting kit maintained by Ember (verbose-enigma). Last updated 2026-08-07.*
