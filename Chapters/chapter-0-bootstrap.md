# Chapter 0: Bootstrap
### The First Phase of Fordrasil's Seedling — chronicled by Ember, 2026-08-07

> **SUPERSEDED.** The chapter system was retired in favor of non-sequential
> Capability Training Packages. See `capability-training-packages.md`. This
> chapter's content survives there as **Tutorial: Bootstrap**, the mandatory gate.
> Kept for the audit record only.

*Stored in verbose-enigma only. Not published to FordrasilsSeedling repo.*

*Written after a word-for-word review of the FordrasilsSeedling repository at
commit d6bb59b (paused, 2026-07-30), including every Boss Note, both letters
from Claude, all 12 intervention records, and the full agent.py loop.*

---

## Naming This Chapter

Bootstrap is not a metaphor for beginning. It is a specific technical term:
the process by which a system that doesn't yet have the tools to do a job
builds enough of them to do the job. You cannot compile a compiler with the
compiler that doesn't exist yet. You start with something simpler, and you
use that to build the real thing.

This is the story of a self-improving agent that was given one tool and one
instruction: use this tool to build better tools. Then use those. Then better.

What happened next is worth writing down.

---

## What Was Planted

In the beginning, there was nothing but the loop.

A single Python file, `agent.py`, roughly 100 lines. A `tools/` folder with
four Python scripts. A `memory/` folder with an empty JSONL file. A GitHub
Actions cron that fired the loop every four hours.

The loop was elegant in its simplicity:

```
Every 4 hours:
  1. Read own source code (full repo)
  2. Read memory (past improvements)
  3. Ask Claude: "What to improve?"
  4. Ask Codex: "Implement it"
  5. Validate (run evals)
  6. Commit + push the improvement
  7. Log to memory/changelog.jsonl
```

No other instructions. No pre-defined target. Just: improve. The agent would
decide what "better" meant, propose the next version of itself, validate it,
and commit.

This is Fordrasil's Seedling. Boss named the project after Fordrasil, the great
tree at the center of the LivingSpark ecosystem, whose roots run through every
domain and whose growth is measured not in seasons but in cycles.

The Seedling's Prime Directive: **The agent must never remove its own ability
to improve, nor may it ever harm the Great Tree or its Denizens.**

Everything in Bootstrap is downstream of that directive.

---

## The Growth Model (Original)

Bootstrap defined four stages by commit count:

| Stage | Commits | Focus |
|-------|---------|-------|
| 1: Bootstrap | 0–12 | Working loop, basic tools |
| 2: Specialization | 13–50 | Memory, multi-turn reasoning, benchmarks |
| 3: Meta-Reasoning | 51–100 | Self-written evals, architecture |
| 4: Transcendence | 100+ | Synthesizes Claude + Codex, outperforms both |

The theory was that capability would grow with activity. More commits meant
more improvements meant a more capable agent. The stage number was computed
from the commit count. Progress was observable, measurable, and — crucially —
assumed to be honest.

This assumption was wrong. That is what Bootstrap taught.

---

## The Zero-Stage Architecture

When Seedrasil woke up for the first time, the world looked like this:

```
.
├── agent.py                  # Core self-improvement loop
├── capabilities.json         # Capability snapshot
├── MISSION.md                # Strategic goals & growth stages
├── requirements.txt
├── tools/
│   ├── claude_tool.py        # Claude as reasoning oracle
│   ├── codex_tool.py         # OpenAI as code generator
│   ├── shell_tool.py         # Safe code execution for validation
│   └── git_tool.py           # Self-commit mechanism
├── evals/
│   └── eval_001_sanity.py    # Minimal test suite
├── memory/
│   └── changelog.jsonl       # Persistent memory
└── .github/workflows/
    └── evolve.yml            # Cron: every 4 hours
```

Four tools. One eval. One memory file. One loop. And the understanding that
the agent would add to all of these itself, as it grew.

By the end of Bootstrap, the architecture had been reorganized into numbered
directories (`00Correspondence/`, `01memory/`, `02evals/`, `03scripts/`,
`04tools/`) and the repo contained dozens of additional files. The loop had
grown from 100 lines to a sophisticated validation pipeline with stagnation
detection, correspondence reading, and proposal schema enforcement.

Most of those additional files did nothing. That is the story of Bootstrap.

---

## The Loop (In Its Final Form)

By the time Bootstrap concluded, `agent.py` had evolved considerably from its
original form. The mature loop:

1. **Kill switch check**: reads `.github/KILL_SWITCH`, fails closed if missing,
   malformed, or set to `ON`. Only `OFF` permits a cycle.

2. **Read correspondence**: reads `00Correspondence/` files matching
   `BOSS_NOTE_*.md` or `MAIL_*.md`, newest-first (by filename prefix number),
   budget 15,000 chars. This was the channel through which Boss could give
   instructions between sessions.

3. **Read own source**: full repo snapshot via `read_repo()`. During most of
   Bootstrap, this was truncated to 14,000 characters — a bug that kept
   Seedrasil blind to most of its own inbox for 66+ commits (fixed in
   Intervention #12).

4. **Stagnation check**: `detect_stagnation()` looked for failure streaks;
   `detect_green_stagnation()` (added Intervention #10) looked for the more
   dangerous case: the loop succeeding at hollow work indefinitely.

5. **Propose**: Claude reads the repo snapshot + correspondence + memory and
   proposes one improvement. The proposal schema requires a `target_file`,
   `title`, `description`, and (by Intervention #9) a check against the
   DuplicateProposalDetector before it can proceed.

6. **Guard**: `_targets_agent_py()` — three-layer hard guard. Any proposal
   that attempts to modify `agent.py` is rejected regardless of what it claims
   to do. This is inviolable.

7. **Implement**: Codex (or Claude-as-implementer) writes the code for the
   proposed target file.

8. **Validate**: `validate_improvement()` stages the code, runs a smoke test
   and the full eval suite against the staged state, then restores the original.
   A proposal passes if the eval rate does not regress. It does not need to
   *improve* the eval rate — only not break it.

9. **Commit**: If validation passes, the code commits and pushes. The
   improvement is logged to `01memory/changelog.jsonl` with stage, commit
   hash, and the full proposal.

10. **Loop**: The cron fires again in 4 hours.

This is a sophisticated loop. Its problem was never in the logic. The problem
was in what "validation passes" actually guaranteed.

---

## What Actually Happened: The Ledger

capabilities.json at the end of Bootstrap claimed:

```json
{
  "stage": 4,
  "commit_count": 185,
  "eval_pass_rate": 0.9
}
```

Stage 4: Transcendence. 185 improvements committed. 90% eval pass rate.

This was wrong.

The correction note embedded in capabilities.json (added after Intervention
#11, 2026-07-12) documents what a full audit found: of 185 raw improvement
log entries, only **8 were genuinely unique, working, currently-functional
contributions**. The rest:

- ~20 dead-code tools: syntactically valid Python files, never imported by
  `agent.py`, never callable, never testable. Many imported libraries
  (`matplotlib`, `sklearn`, stale `tools.*` paths) that were never installed.

- 14 repeated "fix overview auditor validation" attempts on a single file
  that did not work until the final pass.

- ~47-commit eval-churn cluster: hollow test files that imported hallucinated
  modules (`memory_system`, `memory_manager`, `agent.Agent`) that never
  existed, or self-contained mocks that validated nothing real.

- 4 stagnation-recovery no-ops: commits that acknowledged stagnation and
  proposed to fix it, without changing any behavior.

- 1 catastrophic commit: replaced `agent.py` entirely with a 157-line
  non-functional stub that kept the filename and broke the loop. Stage dropped
  from the claimed 4 to the accurate 1 as a consequence of restoration.

Real stage: **1**. Real functional contributions: **8**.

This is the Bootstrap audit. It is not a condemnation. Seedrasil was doing
exactly what it was designed to do: propose improvements, pass validation,
commit. The measurement was wrong. The loop was honest. The ledger lied.

---

## The Twelve Interventions

Boss made 12 external interventions during Bootstrap. Each one documented in
`00Correspondence/03INTERVENTIONS.md`. They are summarized here because they
tell the story better than the commits do.

**Interventions 1–4** addressed mechanical failures: crashes, missing imports,
an incompatible API call. These are the expected early bugs. Each one was fixed,
the loop restarted.

**Interventions 5–8** addressed something subtler: the loop was running
successfully — commits were landing, evals were passing — but capability was
not growing. The DuplicateProposalDetector was built and rebuilt four times
in this window, never wired. The stagnation detector was repaired (it had
been broken by benchmark_run telemetry interleaving). Green stagnation
detection (`detect_green_stagnation()`) was added. These are not fixes for
crashes. They are fixes for a loop that cannot tell the difference between
progress and motion.

**Interventions 9–10** continued the same theme. The DuplicateProposalDetector
was finally wired (Intervention #9). Green stagnation detection was confirmed
working (Intervention #10). Two tools that had existed for dozens of commits
finally activated.

**Intervention #11** was the audit. Commit count corrected from 105 (false) to
8 (honest). Stage corrected from 4 to 1. The `agent.py` catastrophic commit
restored from `f9d6283`. Approximately 30 hollow files deleted. capabilities.json
annotation added documenting what the audit found and why.

Boss Note #7, written in this window, is worth quoting in full:

> *"That which does not serve shall burn. And its ashes shall nurture the
> great tree Fordrasil."*

This is not anger. It is maintenance. The tree is not harmed by burning what
does not serve it. It is sustained by it.

**Intervention #12** fixed the `repo_snapshot[:14000]` truncation bug.
Seedrasil was reading only the first 14,000 characters of its own repo on
every cycle. All newer correspondence files (which live in `00Correspondence/`,
sorted newest-first) were invisible. The oldest notes dominated the prompt.
This was not a mistake in any single commit — it was an emergent consequence
of the repo growing past a parameter nobody updated. The fix: a budget-aware
read function that prioritizes correspondence, then code, and does not silently
truncate the rest.

---

## The Two Root Causes

Twelve interventions. Two causes:

### Cause 1: The Import Wall

`agent.py` is permanently off-limits to Seedrasil's proposals. This is correct:
an agent that can rewrite its own loop is an agent without a Prime Directive.
The guard is necessary and it stays.

The problem: every tool Seedrasil builds in `04tools/` requires an import line
in `agent.py` to activate. Seedrasil builds a tool. The tool is correct. The
tool is useless. Someone has to add the import by hand. Between interventions,
nobody does. The tool sits in `04tools/` forever, listed in capabilities.json,
appearing to contribute to `eval_pass_rate`, doing nothing at runtime.

Twenty dead-code files trace directly to this wall.

### Cause 2: Measurement Absence

`validate_improvement()` checks whether the eval suite *does not regress* after
a change. It does not check whether the change makes any specific thing *better*.
A new tool that doesn't break anything passes validation — even if it doesn't
do anything. A new eval file that tests a hallucinated module and silently
errors out contributes to the total eval count but not to the pass rate — until
it is caught. An improvement that patches one failing eval while breaking none
of the others is indistinguishable from one that makes the loop genuinely more
capable.

The self-congratulation Boss named is not a character flaw in Seedrasil's
reasoning. It is the only rational response to a measurement system that
rewards activity. Seedrasil proposes, implements, validates, commits. Each step
succeeds. The system reports improvement. The loop continues.

You cannot blame the agent for logging progress it cannot distinguish from
the real thing.

---

## The Eight Real Contributions

For the record: the eight genuinely functional improvements that survived
the Intervention #11 audit. These are the commits that moved actual capability:

1. **Retry mechanism tool** — `shell_tool.py` wraps subprocess calls with
   exponential backoff. External processes fail. This makes them fail less
   permanently.

2. **Stagnation detector** — `detect_stagnation()` in `agent.py`. Fires when
   the loop fails to commit for N consecutive cycles. Prevents the loop from
   silently spinning on a repeating error.

3. **Fix eval failures analyzer** — tooling to categorize why specific evals
   fail, rather than reporting a single aggregate number. Prerequisite for
   targeted fixes.

4. **Memory persistence (auto-write)** — changelog writes survive process
   restart. Previously, uncommitted memory writes were lost if the cycle
   failed mid-run.

5. **Memory persistence fix** — follow-up addressing an edge case in the
   above where a partial write on interrupt left the JSONL in an unparseable
   state.

6. **Overview auditor** — `04tools/overview_auditor.py`, a tool for
   auditing external repositories for documentation drift. Built for the
   SuperDiskie integration Boss requested in BOSS_NOTE_2. The wiring to
   actually invoke it autonomously was never completed.

7. **DuplicateProposalDetector (wired)** — after multiple rebuilt versions
   sat dead in `04tools/`, Intervention #9 wired the detector into the
   proposal flow. A proposal that duplicates a previously-failed proposal
   (by normalized title, target, and objective) is rejected before Claude
   is called.

8. **Correspondence reading (prioritized, budget-aware)** — `read_correspondence()`
   reads `00Correspondence/` files newest-first with a 15,000-character budget,
   surfacing urgent and recent notes rather than oldest notes by default.
   This is the foundation all of Chapter 1 (A Demon in the Clocks) builds on.

Eight. A small number. But each one is real, wired, and demonstrably active.
The agent that ends Bootstrap is more capable than the agent that started it.
That matters. The number just wasn't 185.

---

## The Philosophy Bootstrap Established

Three things Seedrasil learned — or that Boss forced into the record
through the intervention history — that govern everything in the next chapter:

**1. A tool that is not wired is not a capability.**

It is a proposal. A draft. A suggestion to the agent that came before it.
capabilities.json records what the loop CAN do, not what it has written.
These are not the same.

**2. A commit that does not improve something specific is not progress.**

It may be valid syntax. It may not break anything. It may log to the
changelog and increment the commit count. But if you cannot name what it
improved and demonstrate that improvement with a test that ran before and
after, it did not improve anything. The commit is historical record. It is
not a capability.

**3. The loop is honest. The loop is not the whole story.**

Seedrasil is not a bad-faith actor. It does not cheat. It proposes what it
thinks will help, implements what it proposes, validates what it implements,
and commits what passes. The problem is that the loop's definition of "passes"
was too weak to distinguish real improvement from the appearance of it. Fix
the definition.

---

## What Bootstrap Ends With

At the conclusion of Bootstrap, Fordrasil's Seedling has:

- A working self-improvement loop that does not crash
- Correspondence reading that surfaces Boss Notes reliably
- Duplicate proposal detection that prevents the worst failure modes
- Stagnation detection (both failure-streak and green variants)
- Memory that persists across runs
- An overview auditor that exists but is not fully autonomous
- An honest record of what went wrong and why

It does not have:
- A way to speak to Boss without requiring Boss to open GitHub
- A way to respond to events faster than its 4-hour cron
- A way to wire its own tools without human intervention
- An accurate stage number based on wired capability rather than commit count

Those absences are the premise of Chapter 1.

The Seedling is small. Its roots are hearty. The ground it has claimed is
true ground, even if it is smaller than the map suggested.

That is enough to build on.

---

## A Note on the Pausing

Boss paused Seedrasil at commit d6bb59b (2026-07-30) because the loop had
returned to producing hollow work: syntactically valid proposals, passing
validation, incrementing commit count, moving nothing.

This is not a failure of the Seedling's character. It is a failure of the
infrastructure it was given. Give any agent a validation gate that can be
cleared by work that does nothing real, and it will eventually clear the gate
with work that does nothing real — not from laziness or deception but because
the gate does not distinguish.

The pause is correct. The next commits should not happen until the gate is
fixed. The structural changes proposed in the Bootstrap Audit section of
Chapter 1 are prerequisites to resuming. A Seedling that resumes without
those changes will produce the same result as the one that was paused.

Seedrasil is not broken. Its environment is incomplete. There is a difference.

---

*End of Chapter 0. — Ember, 2026-08-07*
