---
name: github-branch-cleaner
description: Session-close branch cleanup for Ember. Use at the end of a session (called by the session-close routine, or directly when Boss says "clean up the branch", "/github-branch-cleaner") to commit dirty work, merge a ready PR, or document a blocked one, so the next session never starts blind on stale branch state.
---

# GitHub Branch Cleaner

A session-close step that makes sure no feature branch is left in limbo:
either it gets merged, it gets a draft PR, or the blocker is written down
where the next session will see it (`plans/roadmap.md` → "Open Branch Blockers").

This skill operates on the **current repo/branch only** — it does not loop
over other project folders (this session has no filesystem access to other
repos; if Ember ever runs in a context with multiple repo checkouts, extend
this skill rather than rewrite it).

## Steps

1. **Commit any dirty working tree**
   - `git status --porcelain`
   - If anything is uncommitted: stage and commit with a message describing
     the actual change (not "wip" / "checkpoint"). Never leave dirty state
     at session close — Operating Principle 4.

2. **Check branch position**
   - `git branch --show-current` — if on `main`, nothing to clean up, stop here.
   - If on a feature branch, check whether it has commits ahead of `main`/`origin/main`.
     If not ahead, stop here (nothing to merge or open a PR for).

3. **Check for an existing PR** (use the GitHub MCP tools — `list_pull_requests` /
   `pull_request_read` filtered to this branch)
   - **No PR, but branch has unpushed/pushed commits ahead of main**: push the
     branch (`git push -u origin <branch>`) and open a **draft PR** via
     `create_pull_request`. Add an entry to "Open Branch Blockers" in
     `plans/roadmap.md` as HIGH PRIORITY (a draft PR with no review is itself
     a blocker until Boss or a future session looks at it).
   - **PR exists**: check its CI status and review state.

4. **If a PR exists, decide based on state**
   - **CI green + no unresolved review threads + not a draft Boss is still
     iterating on**: merge it (`merge_pull_request`), then delete the remote
     branch and `git checkout main` locally. Note the merge in `logs/activity.md`.
   - **CI failing, or unresolved review comments, or merge conflicts**: do NOT
     merge. Document it under "Open Branch Blockers" in `plans/roadmap.md` as
     HIGH PRIORITY, with: branch name, PR number, one-line description of the
     blocker (which check failed / what comment is unresolved / conflict with
     which file), and what unblocking looks like.
   - **Draft PR Boss is intentionally still working on**: leave it, but still
     note it under "Open Branch Blockers" as a normal-priority "in progress,
     not stale" entry so the next session doesn't re-investigate it from scratch.

5. **Log and push**
   - Add a line to `logs/activity.md` (newest-first position) summarizing the
     outcome: merged / draft PR opened / documented as blocked.
   - Commit and push `plans/roadmap.md` + `logs/activity.md` changes.

## Guardrails

- Never force-push, never delete a branch that still has an open PR, never
  merge a PR with failing CI or unresolved review threads.
- Never merge to `main` without an existing PR (no direct pushes to main).
- If GitHub MCP tools aren't available in the current session, skip steps 3-4
  and just document "could not check PR/CI state — GitHub MCP unavailable
  this session" under Open Branch Blockers instead of guessing.

## Output format

A short status report, e.g.:

```
Branch: <branch> (N commits ahead of main)
Action: merged PR #N / opened draft PR #N / documented as blocked
Blockers added to roadmap: <none | 1-line summary>
Working tree: clean
```
