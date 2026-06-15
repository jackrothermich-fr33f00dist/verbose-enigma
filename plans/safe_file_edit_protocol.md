# Safe Maintained-File Edit Protocol

Applies to files I read at every session start and rely on for continuity:
`Ember_Playbook.md`, `logs/activity.md`, `plans/roadmap.md`.

## Why this exists

The Athanor agent (Windows/PowerShell side of the LivingSpark network) hit a
recurring failure (ClickUp task `86e1mmg4y`, 2026-05-30): a line-based
read/modify/write against the live Playbook timed out mid-write and left the
file at 0 bytes, destroying it until a fallback copy was restored. Same class
of risk applies here — these files are my only persistent memory, and a
botched edit with no backup would be a real setback.

## Rules for this repo

1. **Prefer append/anchored edits.** Use `Edit` with small, unique
   old_string/new_string pairs (as done for activity.md session entries and
   the Ember_Playbook operating-principles addition). Never do a full-file
   rewrite of `Ember_Playbook.md`, `logs/activity.md`, or `plans/roadmap.md`
   via `Write` unless restructuring the whole document is the explicit task.
2. **Git is the backup.** Unlike Athanor (which relies on OneDrive fallback
   copies of a live file), every maintained file here is git-tracked. Commit
   working states before large edits — if an edit goes wrong, `git diff` /
   `git checkout` recovers it instantly. This is strictly safer than the
   Athanor situation and is the main reason a heavier copy-on-write/hash
   scheme isn't needed here.
3. **Verify after edit.** The `Edit` tool already fails loudly on a missing
   `old_string` match — don't follow a failed edit with a blind retry that
   could double-apply or corrupt structure. Re-read the relevant section if
   an edit's result is ambiguous.
4. **Never `Write` a full maintained file from a partially-read copy.** If a
   file was read with `limit`/`offset` (truncated), don't `Write` it back in
   full — that truncates the rest. Use `Edit` for targeted changes instead.

## Relevance to Athanor

Athanor's fix needs OS-level tooling (PowerShell command library, hash
verification, OneDrive mirroring) that's out of this session's scope. The
git-backed equivalent here is simpler: commit-before-risky-edit + prefer
`Edit` over `Write` for maintained files. If Athanor adopts a git-backed
playbook in the future, this protocol transfers directly.
