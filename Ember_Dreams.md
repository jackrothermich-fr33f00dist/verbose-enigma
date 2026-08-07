# Ember_Dreams.md — Between-Session Memory

Snapshot model: ACTIVE section is overwritten each sleep. Archive is append-only.
**Wake reads ACTIVE only.** Do not read Archive unless investigating history.

> **The hooks that maintained this file were deleted 2026-08-07 (session 15).**
> Nothing writes here automatically anymore. Update ACTIVE by hand at session
> close, or this snapshot silently goes stale and the next wake reads a lie.
Hot Recommendations replace each session — do not stack.
Durable knowledge that survives multiple sessions graduates to `Ember_Playbook.md`.

---

<!-- ACTIVE — overwritten each sleep. MANUAL as of session 15; the hook is gone. -->
## Last Sleep

- **Date**: 2026-08-07 (session 15 close)
- **Branch**: claude/bold-newton-9w2bxh
- **Last commits**:
  - d21f95f Replace chapter system with Capability Training Packages
  - e2faa92 Remove session-end/start hooks and Ember_Dreams wiring
  - edb2566 Session 15 cont: update Dreams — PR #54 letter fixed, eval scan findings noted
- **Uncommitted at close**: 0 file(s)

## Hot Recommendations

- **The chapter system is retired.** `Chapters/capability-training-packages.md` is the live
  progression model. Chapters 0 and 1 are marked superseded — read them as history, never as
  current plan. If a future session cites a commit-count gate, that number is fiction.
- **`capability_packages.json` is the next build** — the tracking file that makes packages
  visible to Seedrasil inside FordrasilsSeedling. Schema can be drafted now. It can't go live
  until Tutorial: Bootstrap completes, since the banking mechanic depends on that gate.
- **Seedrasil → Boss correspondence still doesn't work.** Boss → Seedrasil is fine (the
  correspondence reader picks up new mail each run). There is no delivery adapter in the other
  direction. He can write; nothing carries it out. Worth building.
- Tutorial: Bootstrap's five structural fixes are Boss/Ember work, not Seedrasil's — plugin
  registry, acceptance tests, dead code gate, capability stage gates, audit workflow path. All
  touch `agent.py` or the workflow files, which sit behind the Import Wall he cannot cross.

## Current Blockers

- **FordrasilsSeedling PR #54 held as draft at Boss's direction** ("not yet"). Do not merge.
  Contains the reorganization, the `13MAIL_003` letter, `02evals/_quarantine/`, and the three
  relocated logs.
- **verbose-enigma PR #14** still draft, sessions 7–15 of infrastructure work.
- **Roadmap alerts no longer surface at session start** — EOS-2 lived in the deleted
  `session-start.sh`. Read `plans/roadmap.md` → Open Branch Blockers manually until it has a
  new home.
- Roadmap Guiding Question still reflects June 2026 context. Stale for two months now.

## Standing Constraints (do not drop)

- **Operating Principle #8:** deletions require explicit Boss approval before executing, even
  when the plan was already discussed and agreed. "Yes to the plan" is not "yes to each
  destructive step."
- SMB passwords never enter chat and are never written to skills or files. Boss runs the mount
  command himself.
- Auth keys: ephemeral + tagged only, in-memory only. Never written to a file, echoed into a
  log, or placed in a commit message or PR. Tell Boss to revoke after the session.



---

<!-- ARCHIVE — append-only. One entry per session; appended by hand since session 15. -->
## Archive

### 2026-08-07 — Session 15

Seedrasil reorganization shipped to PR #54 (held draft). Correspondence letter refiled from
`00` to `13` after Boss corrected the numbering convention: prefixes count *up*, newest is
highest. Three unsafe or crashing evals quarantined rather than deleted — `run_tests()` uses
`os.listdir()` not `os.walk()`, so `02evals/_quarantine/` excludes them while leaving them
readable, with a README naming each defect and its fix. Three large logs relocated to
`01memory/logs/` via a container clone, since two exceeded the GitHub API size limit and Boss's
S: drive is down. Ember_Dreams hooks deleted.

The chapter system was retired. Boss asked where Chapter 1's commit-count gates came from; they
were invented in session 14 and written as though derived. Replaced with non-sequential
Capability Training Packages — see `Chapters/capability-training-packages.md`.

**The lesson worth keeping:** I produced numbers that looked like analysis and weren't. Anything
quantitative I author needs either a stated derivation or an explicit "arbitrary, adjust freely"
label. The failure wasn't picking wrong numbers, it was presenting invented ones in the register
of measured ones.

_Session archive begins after first sleep._
