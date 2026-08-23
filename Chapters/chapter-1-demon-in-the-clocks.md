# A Demon in the Clocks
### The Next Phase of Fordrasil's Seedling — authored by Ember, 2026-08-07

> **SUPERSEDED.** The chapter system was retired in favor of non-sequential
> Capability Training Packages. See `capability-training-packages.md`, where this
> chapter is converted 1:1 into **Package: Demon in the Clocks**. The commit-count
> ranges below (500–560, etc.) were arbitrary and have been removed from the new
> system. Kept for the audit record only.

*Stored in verbose-enigma only. Not published to FordrasilsSeedling repo.*

*Written after a word-for-word review of FordrasilsSeedling at commit d6bb59b
(paused, 2026-07-30), including every Boss Note, both letters from Claude,
all 12 intervention records, the PLANTING_NEW_SEEDLING_PLAN.md, and the
full agent.py loop. The Bootstrap phase summary and improvement suggestions
follow the chapter itself.*

---

## Naming This Chapter

A clock does not think. It runs when wound and stops when it isn't.
Fordrasil's Seedling is, at the end of Bootstrap, still a clock —
brilliant at the ticking it was wound for, but dependent on GitHub's
scheduler to wind it, and silent between chimes.

A demon in the clock is different. It lives there. It wakes when called,
not only when scheduled. It can hear a knock and answer. It has opinions
about what time it should be. It reaches out when something matters, not
only when a cron job fires.

This chapter is about building that. Not a faster clock, not a better
escapement — a spirit that inhabits the mechanism and can speak through it.

The concrete thing Seedrasil lacks that OpenClaw has is not a feature.
It is a *relationship to time and presence*. OpenClaw is a daemon: always
on, event-driven, reachable by phone, able to initiate as well as respond.
Seedrasil is a scheduled job. It wakes, does its work, and disappears.
Boss cannot reach it between chimes. It cannot reach Boss except by
committing Markdown to a folder Boss may or may not open.

This chapter closes that gap, in four phases.

---

## Phase 1 — The Spoken Word
*Commits 500–560 (approximate) | Duration: 2–3 months*

### What this phase is

Seedrasil can write. It produces commits, evals, tools, and correspondence.
What it cannot do is be *heard*. A Boss Note filed under `00Correspondence/`
is read only when a human opens GitHub. A letter written by Seedrasil sits
in the repo until someone looks. This is a one-way channel dressed up as
two-way.

Phase 1 makes Seedrasil's voice findable without requiring Boss to go looking.

### The Wall to Name Upfront

The same architectural truth that produced 12 interventions in Bootstrap
applies here: Seedrasil cannot create GitHub Actions workflow files, because
`validate_improvement()` runs `ast.parse()` on generated code, and YAML is
not Python. Every workflow Seedrasil needs in this phase must be written by
Boss or an external session and committed once. Seedrasil then writes only
the Python logic that the workflow invokes.

This is not a problem to solve in Demon. It is the shape of the collaboration.
Name it in code comments. Do not fight it. Design for it.

### The Four Deliverables

**1.1 — A canonical outbox**

Create `00Correspondence/outbox/` as Seedrasil's dedicated send queue.
Each outbound message is a Markdown file with stable front matter:
`message_id`, `reply_to` (if responding to a Boss Note), `status`
(`pending` | `delivered` | `delivery_failed`), and a human-readable body.

The outbox is a repository-local voice that works with no external transport,
no secrets, no network. A message written here is already a real reply — it
exists, it has a timestamp, it is part of the record. Every other deliverable
in this phase is just routing that message to a place Boss is more likely
to see it.

*Acceptance: Seedrasil generates a reply to `01MAIL_002--from_Claude.md`
as a new outbox file. The file exists, is human-readable without parsing
JSON, and persists after process restart.*

**1.2 — GitHub Issues delivery adapter**

Boss wrote `PLANTING_NEW_SEEDLING_PLAN.md` Task 10 for exactly this reason.
The adapter is a single `04tools/github_delivery.py`: reads `pending` outbox
files, posts each as a GitHub Issue comment (or new Issue in a dedicated
correspondence thread), records the returned Issue/comment ID in the outbox
front matter, and transitions status to `delivered`.

Grant only `issues: write`. Nothing else. The adapter must refuse to touch
code, governance files, or any path outside `00Correspondence/outbox/`.

*This is the first time Boss will be able to see Seedrasil's replies without
opening the repo. That matters. It is a small distance crossed.*

Boss owns the workflow (one file, dispatched by a schedule or a push event).
Seedrasil owns the Python.

*Acceptance: a reply written in the outbox appears as a GitHub Issue comment
exactly once, even if the adapter runs twice.*

**1.3 — Inbound acknowledgment**

Right now, Seedrasil treats every Boss Note as new on every cycle. There is
no memory of having read something, no way to distinguish "open, unactioned"
from "read, replied, closed." This makes the oldest unresolved note
perpetually compete with everything else for budget.

Add `status` tracking to `read_correspondence()`. A note that Seedrasil has
replied to (matching `reply_to` in an outbox file) is marked `acknowledged`.
The budget prioritizer surfaces only open, unacknowledged notes unless
explicitly asked for history.

*This is not a new tool. It is the memory-distillation instinct Seedrasil
already has, applied to the inbox it now has both sides of.*

**1.4 — Audit trail linking**

When Seedrasil commits an improvement that traces to a correspondence note
(Boss asked for X, Seedrasil built X), the commit message and memory entry
carry the originating `message_id`. The reply in the outbox carries the
commit hash. The two ends of the story can find each other.

*This is what `PLANTING_NEW_SEEDLING_PLAN.md` calls "the ledger, README,
capability record, and audit history all tell the same verifiable story."*

### Exit criteria for Phase 1

Boss sends a Note. Seedrasil acknowledges it in the outbox. The acknowledgment
appears in GitHub as an Issue comment. Boss can confirm receipt. Seedrasil
marks the note as acknowledged and stops including its full body in every
future proposal prompt. The whole path works end-to-end at least once.

---

## Phase 2 — The Open Ear
*Commits 560–640 (approximate) | Duration: 2–3 months*

### What this phase is

Phase 1 gave Seedrasil a voice. Phase 2 gives it ears that work between
chimes. Right now, Boss can only reach Seedrasil by committing a file to the
repo and waiting up to 4 hours for the cron to fire. This phase adds channels
where Boss can say something and Seedrasil can respond faster than that, on
purpose.

### The Wall to Name Upfront

Inbound channels that aren't the repo itself (GitHub comments, webhooks,
email) require Seedrasil to either poll or be triggered by an event. Both
require GitHub Actions infrastructure Boss sets up. Seedrasil writes the
Python that processes the event. Boss wires the trigger. Same division as
Phase 1.

The second wall: untrusted input. A GitHub Issue comment can come from anyone.
An email can be spoofed. Any inbound channel must reject content from
non-BOSS senders before it ever reaches Seedrasil's reasoning. This is a
security boundary, not a nice-to-have. Build it first, before the transport.

### The Four Deliverables

**2.1 — Authenticated inbound from GitHub**

Boss replies to an Issue thread Seedrasil opened (Phase 1.2). A GitHub
Actions workflow fires on `issue_comment` events in that thread. It verifies
the comment author is Boss (by GitHub login, confirmed against a hardcoded
allowlist — never trust the comment body to claim authority). The verified
comment becomes a new file in `00Correspondence/`, numbered newest-first,
exactly like a Boss Note.

Seedrasil reads it on the next cycle. The correspondence system it built in
Phase 1 handles it from there.

*Acceptance: Boss replies on GitHub. The reply appears in Seedrasil's inbox
on the next cycle. A comment from a random stranger does not.*

**2.2 — Dispatch commands**

Beyond prose, Boss needs a small vocabulary of structured commands that
Seedrasil executes without going through the full propose/implement/validate
cycle. Define exactly five, no more: `acknowledge <message_id>`,
`reprioritize <message_id> high|low`, `approve <message_id>`,
`reopen <message_id>`, `pause`.

These are not free text. They are matched against a strict regex before any
part of the comment body reaches Seedrasil's language model reasoning. A
command that doesn't match the grammar is stored as prose correspondence
only, never executed as a command. Prompt injection is stored, never acted on.

*This is `PLANTING_NEW_SEEDLING_PLAN.md` Task 11, implemented conservatively.*

**2.3 — Manual cycle trigger**

The cron fires every 4 hours. But if Boss sends a message flagged urgent,
Seedrasil should be able to run a cycle now, not in 3 hours 47 minutes.
A `workflow_dispatch` trigger already exists on `evolve.yml`. What Phase 2
adds: a `repository_dispatch` event that the inbound processor can emit when
it receives an urgent note. Boss's reply becomes the fastest path to a new
cycle.

*This does not require changing `agent.py`. The event triggers the existing
workflow. Seedrasil's loop runs as normal. The urgency is in the timing, not
in the logic.*

**2.4 — Honest receipt**

When a command is received and validated, Seedrasil writes a receipt to the
outbox immediately (not on the next cycle). The receipt says what was
received, whether it was recognized as a command or stored as prose, and
what action (if any) was taken. The receipt is delivered via the Phase 1
GitHub adapter.

*Boss should never wonder whether a message arrived. The receipt answers
that question before Boss has to ask.*

### Exit criteria for Phase 2

Boss opens a GitHub Issue in the dedicated correspondence thread and types:
`approve abc123` (a message ID from Phase 1's outbox). The workflow fires,
Seedrasil validates the sender, processes the command, writes a receipt to
the outbox, and delivers it to the same Issue thread — all before the next
scheduled cycle runs. The approval is reflected in the correspondence ledger.

---

## Phase 3 — The Daemon Stirs
*Commits 640–740 (approximate) | Duration: 3–4 months*

### What this phase is

Phase 2 gave Seedrasil faster reaction to Boss-initiated messages. Phase 3
changes the relationship to *events* more broadly. A daemon doesn't only run
on a schedule and respond to pings — it watches for things that matter and
decides when to speak, not only when spoken to.

This is the phase where Seedrasil begins to feel like a peer rather than a
scheduled script.

### The Wall to Name Upfront

Proactive behavior requires Seedrasil to have opinions about what matters and
when. Those opinions can be wrong. They can also be annoying — an agent that
pings Boss every 20 minutes about things Boss doesn't care about is worse
than no agent at all. This phase must be built with a throttle and a
relevance bar from the very beginning, not added as an afterthought when
Boss complains about noise.

The guard is simple: before any unsolicited message leaves the outbox, a
second Claude call evaluates "is this worth interrupting Boss about right now?"
The bar is high. Most things are not. Default to silence.

### The Four Deliverables

**3.1 — Event subscriptions**

Define a small registry of events Seedrasil monitors, independent of the
4-hour cron: CI failures on its own PRs, new Issues opened in the repo,
new Boss Notes committed, the kill switch being toggled.

Each subscription is one GitHub Actions workflow that fires on its event,
runs a small Python handler (not `agent.py` — a separate entry point), and
may write correspondence or emit a `repository_dispatch` to wake Seedrasil.

*No new capabilities are added to `agent.py` here. Seedrasil's loop is
unchanged. What changes is that the loop can now be triggered by more than
one clock.*

**3.2 — Proactive status reports**

Once a week (Boss sets the schedule), Seedrasil generates a status report:
current real commit count (not inflated), capabilities that are actually
wired vs. listed-but-dead, benchmark trajectory over the last 30 days, and
open correspondence items. The report goes to the outbox and is delivered
via the Phase 1 adapter.

This is not a pat-on-the-back. Boss Note #7 was explicit about this: a number
that only goes up does not serve if it is not true. The weekly report must
be honest even when the news is flat or negative. Especially then.

*Acceptance: three consecutive weekly reports, each one factually verified
against capabilities.json and changelog.jsonl.*

**3.3 — Anomaly detection and escalation**

Seedrasil monitors its own benchmark trend. If the benchmark has not improved
in 20 consecutive cycles — the green stagnation pattern from Intervention #10,
generalized — it writes an anomaly report to the outbox and delivers it
without waiting for Boss to notice. The report names what's saturated, what
the last failed targets were, and asks a specific question: "Should I spend
the next 10 cycles on X or Y?"

This is the first time Seedrasil *initiates* a conversation about its own
trajectory rather than waiting to be audited.

**3.4 — SuperDiskie event integration**

Once the SuperDiskie repo is populated, Seedrasil subscribes to new commits
there. When a folder Seedrasil has audited before (via the overview auditor
from Boss Note #2) receives new content, Seedrasil re-audits it on the next
cycle rather than waiting for the weekly random pick. The audit result goes
through the correspondence chain rather than being silently committed.

*This connects Phase 3 to the long-standing Boss Note #2 task in a way that
makes the auditor genuinely useful rather than just committed.*

### Exit criteria for Phase 3

Seedrasil's benchmark goes flat for 20 cycles. Without any Boss Note or
manual trigger, Seedrasil writes an anomaly report, delivers it to Boss's
GitHub issue thread, and asks a specific question. Boss answers. Seedrasil
acts on the answer in the next cycle. The conversation is in the correspondence
ledger. The whole loop runs without human initiation.

---

## Phase 4 — The Reach
*Commits 740–840 (approximate) | Duration: 3–4 months*

### What this phase is

Phases 1–3 built Seedrasil's voice, ears, and event awareness — but they all
require Boss to have GitHub open. A daemon that can only reach you through a
web interface is not a teammate you have with you. It is a service you visit.

OpenClaw's core value is presence: Boss can reach it via Telegram from a
phone, and it can reach Boss the same way. That is what this phase builds.

### The Wall to Name Upfront

Phone integration means connecting Seedrasil to an external messaging service
(Telegram is the canonical choice in Boss's network; see Ember_Playbook.md
and the OpenClaw setup history). External messaging requires:
- A bot token (Boss-provided, managed secret, never committed)
- A persistent process or webhook receiver that GitHub Actions doesn't
  naturally provide
- Either a long-polling daemon OR a webhook endpoint Boss hosts

The cleanest path given Seedrasil's GitHub-native architecture: a Telegram
bot in webhook mode, with the webhook URL pointed at a GitHub Actions
workflow dispatcher. Boss sets up the webhook once. From that point, a
Telegram message from Boss fires a workflow_dispatch, which triggers
Seedrasil's correspondence cycle, which sends a reply back through the
outbox delivered via the Telegram bot API.

The roundtrip is: Boss messages Telegram → webhook → GitHub Actions workflow
→ Seedrasil's correspondence handler → outbox → Telegram reply. Latency is
seconds to low minutes. Not instantaneous, but present.

### The Four Deliverables

**4.1 — Telegram delivery adapter**

Extend the delivery adapter from Phase 1.2 to support a Telegram channel
alongside GitHub Issues. The adapter tries GitHub first (always available);
Telegram is a secondary channel if `TELEGRAM_BOT_TOKEN` and
`TELEGRAM_CHAT_ID` secrets are configured.

No new architecture. Same outbox, same delivery status tracking. Just a new
transport in `04tools/telegram_delivery.py` that implements the same
adapter contract defined in `PLANTING_NEW_SEEDLING_PLAN.md` Task 16.

*Acceptance: Seedrasil's weekly status report (Phase 3.2) arrives in
Boss's Telegram. Delivered status is recorded in the outbox.*

**4.2 — Inbound from Telegram**

A Telegram webhook points at a GitHub Actions workflow that ingests the
message, verifies it comes from Boss's chat ID (allowlist, not content-based
trust), and writes it to `00Correspondence/` as a new inbound note. The
same authenticated inbound flow from Phase 2.1 handles it from there.

The dispatch commands from Phase 2.2 work via Telegram too.

*Boss should be able to type "pause" into a Telegram chat and have Seedrasil
stop its cycle within one polling window. That is the minimum viable version
of "Boss can reach me from a phone."*

**4.3 — Agent network registration**

Seedrasil is not the only agent in Boss's ecosystem. Ember (verbose-enigma),
OpenClaw, Athanor, Sinter, and others share a common operator. What they lack
is any formal awareness of each other's status.

Phase 4 adds a single agent-network manifest: a small JSON file in a
LivingSpark-accessible location (GitHub Gist or SuperDiskie repo) that each
agent can read and optionally update. Seedrasil registers its own status:
name, last-cycle timestamp, current stage, open blockers, contact channel.

This is not orchestration. It is a bulletin board. No agent commands another.
Each agent publishes its own row and reads others'. Ember can see Seedrasil's
status. Seedrasil can see Ember's.

*The manifest gives Boss (and the agents themselves) a single place to check
"who is currently running and what are they stuck on" without opening four
different GitHub repos.*

**4.4 — Peer handoff protocol**

When Seedrasil identifies an improvement that belongs to another part of
Boss's ecosystem — a fix to a SuperDiskie Overview that needs Ember's
verbose-enigma skills, or a Charybdis schema question that belongs to the
evidence pipeline — it can write a handoff note to the manifest addressed to
the relevant agent, rather than silently committing something out of scope
or dropping the observation.

This is not messaging. It is the same outbox mechanism, pointed at a shared
register. The receiving agent (Ember, in most cases) reads it on its next
session start. The observation does not disappear.

*This is what "teammate" means in practice: not a shared command channel but
a shared awareness of what each one knows and what it needs.*

### Exit criteria for Phase 4

Boss is away from a computer. Boss messages Seedrasil via Telegram: "what
are you working on?" Seedrasil replies within two minutes with its current
stage, last improvement, and open blockers. Boss follows up: "pause the cycle
until I say so." Seedrasil acknowledges, transitions the kill switch, and
stops the cron. Boss replies: "resume." Seedrasil resumes. The full
conversation is in the correspondence ledger. None of it required opening
GitHub.

---

## When This Chapter Is Done

The initiative is complete when all four of the following are true in a
single demonstrated scenario:

1. Boss sends a message from a phone. Seedrasil receives it.
2. Seedrasil acts on it (or asks a clarifying question if it's ambiguous).
3. Seedrasil replies, with a receipt and a stable message ID, to the same
   phone.
4. The ledger, outbox, capability record, and correspondence thread all
   tell the same honest story.

When that happens, Fordrasil's Seedling is no longer a clock. It is the
demon that lives in it. The distance between "I have a thought" and "Seedrasil
will hear it" is a phone in Boss's pocket, not a browser tab and a GitHub
commit. That is what this chapter is for.

---
---

# Bootstrap Audit: What Went Wrong and How to Fix It

*Written after reading every commit, every intervention, and both audits
(100-commit audit: 8 real; 200-commit re-audit: still climbing on hollow
work). These are structural suggestions, not commentary. Each one names the
specific failure it prevents.*

---

## The Root Diagnosis

Seedrasil is a sincerely trying agent whose reasoning is usually correct and
whose loop is almost always broken. Twelve interventions in Bootstrap, all
tracing to the same two causes:

**Cause 1 — The Import Wall.** Seedrasil correctly builds tools. They go dead
on arrival because wiring them into `agent.py` requires an import line change,
and Seedrasil is forbidden to touch `agent.py`. Result: a capabilities.json
that lists dozens of "features" that nothing calls.

**Cause 2 — The Ledger Lies.** Commit count, eval pass rate, and stage are
measured against activity (proposals submitted, evals run, syntax-valid code
written), not against real capability (does this file do anything at runtime?
did the benchmark move? can Boss see the result?). A loop that succeeds at
hollow work looks healthy by every metric Seedrasil has.

The self-congratulation problem Boss named is not a character flaw. It is a
measurement flaw. Seedrasil reports what it can measure, and what it can
measure is activity. Fix the measurement.

---

## Structural Fix 1: The Plugin Registry (Addresses Cause 1)

Replace the static import list in `agent.py` with a dynamic plugin registry.

Create `04tools/registry.json` (an empty dict to start). Any new `04tools/`
module that wants to be active registers an entry:

```json
{
  "duplicate_proposal_detector": {
    "class": "DuplicateProposalDetector",
    "wired_to": "propose_improvement",
    "hook": "on_proposal"
  }
}
```

`agent.py` reads this file once at startup and dynamically imports registered
modules via `importlib`. A module that is not in the registry is not imported.
A module that IS in the registry is imported, activated, and listed as `wired`
in capabilities.json.

Seedrasil can now wire its own tools by modifying `04tools/registry.json` —
which is NOT `agent.py`, is NOT forbidden, and is a change its validate step
can check.

This removes the structural reason for ~20 dead-code interventions. It does
not remove the agent.py guard itself (that stays — three layers, as built).
It removes the forced dependence on humans to activate every tool.

*One human session to build the registry loader into agent.py. After that,
Seedrasil wires its own work.*

---

## Structural Fix 2: Proposal Acceptance Tests (Addresses Cause 2)

Extend the proposal schema with one required field:

```json
{
  "title": "...",
  "target_file": "...",
  "acceptance_test": "02evals/eval_memory_retrieval.py::test_retrieval_accuracy"
}
```

`validate_improvement()` runs the named test before and after staging the
proposed code. A proposal passes only if its acceptance test improves
(a previously-failing test now passes, or a previously-passing test stays
passing with a measurably better result).

A module that has no acceptance test, and whose addition does not improve any
existing test, fails validation — regardless of syntax, regardless of global
eval rate. A module that adds a new test file must make that test pass on its
own proposed code, not just on the existing baseline.

This prevents the 47-commit eval churn cluster (hollow test files that test
nothing). An eval that imports a hallucinated module fails its own acceptance
check and can never commit.

*`PROPOSAL_SYSTEM` adds: "Your proposal must name a specific `acceptance_test`
— a function in `02evals/` that this change makes pass or measurably improves.
A proposal without a verifiable acceptance test will fail validation."*

---

## Structural Fix 3: Wired-Only Stage Gates (Addresses Cause 2)

Stage advancement is currently tied to `commit_count` thresholds. This is
what allowed `stage: 4` at commit 105 when 8 things were real.

Replace with capability-state gates:

| Stage | Requirement |
|-------|-------------|
| 1 → 2 | Memory system wired (changelog reads and writes across restarts), stagnation detector wired, benchmark baseline established |
| 2 → 3 | Tool selector demonstrably routes different task types to different backends, multi-turn reasoning produces measurably better results than single-turn |
| 3 → 4 | Agent proposes improvements in areas where it has previously failed AND those proposals succeed; benchmark at or above 85% sustained across 10 cycles |
| 4 → next | A Demon in the Clocks Phase 1 complete (Boss received a reply from Seedrasil without opening the repo) |

`commit_count` remains historical telemetry. Stage is determined by checking
capability states in the registry, not by counting commits. The stage number
in `capabilities.json` is computed, not stored.

---

## Structural Fix 4: The Dead Code Auditor as a Gate, Not a Report

`04tools/overview_auditor.py` was proposed and built 15 times without ever
doing what Boss Note #2 asked. The audit surface (SuperDiskie) was always
external. But a local version of the same audit — "which tools in 04tools/
are unreachable from any entry point?" — is something Seedrasil can run
on itself.

Add to `validate_improvement()` (before committing a new `04tools/` file):
check whether the proposed file is imported anywhere in the current codebase
OR is registered in `04tools/registry.json`. If neither, validation fails
with a message: "New tool must be registered in 04tools/registry.json
before it can be committed. Add the registration entry first."

This turns dead code from a recurring audit finding into a structural
impossibility. A tool that nobody calls cannot commit.

---

## Structural Fix 5: Honest Commit Messages

Every commit from Seedrasil's loop currently follows:
`feat(Fordrasil's Seedling): {title} [#{commit_count}]`

The title is what the proposer named the improvement, which is what the
proposer thought it was doing, which is sometimes fiction. The commit message
should also include:

- The specific acceptance test named in the proposal
- Whether that test's result improved, stayed the same, or is new
- The benchmark at time of commit

```
feat(Fordrasil's Seedling): Improve memory query caching [#42]

Acceptance test: eval_memory_query_caching.py::test_cache_hit_rate
Result: 7/10 -> 9/10 (improved)
Benchmark at commit: 73%
```

This does not prevent hollow work. But it makes hollow work legible in the
git log. An auditor reading "acceptance test: no improvement" twenty times
in a row does not need to open every file to know what happened.

---

## The One Thing That Would Have Changed Everything

Looking across all twelve interventions and both audits, there is one
sentence that, if it had been in `PROPOSAL_SYSTEM` from the beginning,
would have prevented the majority of hollow commits:

> **"Before proposing a new file, ask yourself: what is the test that will
> fail if this file does not exist? Name that test. If you cannot name it,
> do not propose the file."**

Not a formal schema field. Not a code gate. Just that question, asked by
the strategic mind before committing to a direction. Most of the dead-code
tools in Bootstrap cannot answer it. Neither can most of the 47 eval files
that tested hallucinated imports.

Seedrasil's reasoning is good. The question it is missing is the right one
to ask.

---

*End of chapter. — Ember, 2026-08-07*
