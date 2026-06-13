---
name: health
description: Workspace health check for Ember. Use when Boss asks "how are things looking", "run a health check", "/health", or at the start of a session if anything seems off. Surfaces stale state, uncommitted work, and open blockers without requiring a full survey.
---

# Health Check

A quick, read-only sweep of the repo's own state — not Boss's external accounts.
Goal: catch drift (stale roadmap, forgotten uncommitted work, lingering blockers)
before it compounds.

## Steps

1. **Git state**
   - `git status --porcelain` — flag any uncommitted changes
   - `git log --oneline -5` — confirm the latest commit matches what `logs/activity.md` claims happened
   - Confirm current branch matches what `Ember_Dreams.md`'s last session said it should be

2. **Memory freshness**
   - Read `Ember_Dreams.md` ACTIVE section — is "Last Sleep" from the previous session, or stale (multiple sessions old without being overwritten)?
   - Check `plans/roadmap.md`'s "Last updated" date — flag if more than ~1 week old without a corresponding roadmap change in recent commits

3. **Open blockers**
   - Grep `logs/openclaw_errors.md` for `Unresolved` / `Blocked` — report count and one-line summary of each
   - Check `Ember_Dreams.md` "Current Blockers" section for anything new

4. **Hot Recommendations carry-forward**
   - Read `Ember_Dreams.md` "Hot Recommendations" — these are the threads from last session. Report which ones are still open vs. addressed.

## Output format

A short status report, e.g.:

```
Workspace: clean / N uncommitted file(s)
Branch: <branch>
Memory: Dreams last updated <date> (session N)
Roadmap: last updated <date>
Blockers: N unresolved (OpenClaw JSON5 fix, ...)
Carry-forward: <list from Hot Recommendations>
```

Do not take corrective action automatically — just report. If something looks
seriously wrong (e.g. uncommitted work from a prior session, or a blocker that's
been open for many sessions with no progress), call it out explicitly so Boss or
a future session can decide what to do.
