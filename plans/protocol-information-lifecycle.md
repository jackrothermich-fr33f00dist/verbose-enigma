# Information Lifecycle Protocol
### How information is created, closed, and retired in LivingSpark repos

*Authored by Ember, 2026-08-07. Applies to `verbose-enigma` and any repo
following LivingSpark conventions.*

---

## Purpose

Information in a living repo has a lifecycle. It starts open, becomes
stale or closed, and eventually needs to be either retired gracefully or
preserved for historical reference. Without a consistent protocol, repos
accumulate ghost references — things that look active but aren't —
which degrades trust in every other piece of information.

This document defines how to handle the full arc: closing tasks,
retiring artifacts, archiving to 99BackUps, writing changelogs, and the
special case of the roadmap.

---

## Closed Task Types

Not all "done" is the same. Use the right label so the history is honest.

| Type | Marker | Meaning |
|------|--------|---------|
| **Completed** | ✅ Done | Finished and working as intended. The thing exists and is in use. |
| **Retired** | ~~Retired~~ or ✅ Done / ~~Retired~~ | Was working; no longer relevant or needed. Not broken — just done serving. |
| **Abandoned** | ~~Abandoned~~ | Started in earnest, did not finish. Stopped due to complexity, changed priorities, or a better path. Worth noting why. |
| **Canceled** | ~~Canceled~~ | Never really started. Decision was made before investment. |
| **Superseded** | ~~Superseded by X~~ | Replaced by a different approach that does the same job better. Name the replacement. |
| **Archived** | 🗄️ Archived | Content preserved for reference but no longer active. Often accompanies Retired or Abandoned. |

Closed tasks stay inline in most documents. They are not moved to a
separate section. The history of what was tried and why it closed is
part of the road — removing it makes the document less honest, not
cleaner. The roadmap especially: see the Roadmap section below.

---

## Changelogs

### Purpose

A changelog records *why the information changed*, not just *what
changed*. A git commit message records what. A changelog entry explains
the decision behind it.

### Format

```markdown
---

## Changelog

### YYYY-MM-DD
- Entry describing what changed and the reason behind it.

### YYYY-MM-DD (older)
- Entry.
```

- Goes at the **very end** of the file, after all content.
- Newest entry at the **top** of the changelog section.
- Oldest entry at the **bottom**.
- One `###` heading per day. Multiple changes on the same day go as
  bullets under one heading.
- One sentence minimum per entry: what changed + why, not just "updated X."

### What belongs in a changelog entry

Good: *"Removed OpenClaw references — OpenClaw is defunct; WSL daemon
approach abandoned in favor of native Claude Code hooks which solved the
same problem with no local infrastructure dependency."*

Not good: *"Updated Ember_Playbook.md to remove OpenClaw section."*
(That's a commit message, not a changelog entry.)

### Document types and changelog flavor

| Document type | Changelog records... |
|--------------|---------------------|
| Operational docs (playbooks, specs, skills) | What changed in the file and why the content needed updating |
| Plans / specs | Why a decision was made, what changed the requirements |
| Roadmap | When sections of road were built or rerouted, and what drove the direction change — a construction log, not a file-edit log |
| Protocol docs (like this one) | When the protocol itself changed and what prompted the revision |

---

## 99BackUps

### What they are

99BackUps folders are named archives. The `99` prefix sorts them to the
bottom of any directory listing, keeping active content visually
dominant. Content inside is reference-only — not actively maintained,
not imported or called by anything live.

### The root 99BackUps

`/99BackUps/` at the repository root is for repo-level retired artifacts:
entire tool stacks, retired configurations, old approach folders. If
something was a top-level concern and is now dead, it goes here.

Structure inside the root 99BackUps mirrors the original location, with
a subfolder per retired system or topic:

```
99BackUps/
└── openclaw/          ← retired daemon stack
    ├── AGENTS.md
    ├── SETUP.md
    ├── openclaw.json
    ├── openclaw_errors.md
    ├── openclaw-alternatives.md
    └── skills/
        └── openclaw-fix/
```

### Mini 99BackUps

A mini `99BackUps/` can live inside any subfolder when that subfolder has
its own retirement needs that don't belong at the repo root. Use a mini
when:

- The retired content is scoped to one domain and unlikely to be
  referenced outside it
- The root 99BackUps would become noisy with many small single-file
  retirements
- The folder it lives in is itself a long-lived section of the repo
  (e.g. `charybdis/99BackUps/`, `plans/99BackUps/`)

Do **not** create a mini 99BackUps just to avoid deleting something.
The question is whether the content has genuine historical reference
value. If it does not, delete it (with approval where required — see
Operating Principles).

### The canonical 99BackUps on S:

The primary LivingSpark archive is on `S:` (FyreHeart-Forge root,
accessible via Tailscale SMB). Content there is long-term preservation
across repos and machines — session logs, large artifacts, superseded
design documents from multiple projects. When S: is accessible, material
from repo-level 99BackUps that has aged past immediate reference value
can migrate there. Until S: is accessible, repo-level 99BackUps serves
as the holding location.

### When to use which

| Situation | Action |
|-----------|--------|
| Retiring an active tool, config, or skill from this repo | Move to `99BackUps/<system>/` at repo root |
| Retiring a draft or plan document | Move to `plans/99BackUps/` (mini) |
| Retiring content scoped to one subsystem | Mini 99BackUps inside that subsystem's folder |
| Long-term cross-repo preservation | S: root (when accessible) |
| Content with no reference value | Delete (with approval) |

### What goes inside a 99BackUps folder

- The retired files themselves, mirroring their original path structure
- Optionally: a `README.md` or `RETIRED.md` in the 99BackUps folder
  explaining what was here, when it was retired, and why — useful when
  the folder contains multiple unrelated items or when the reason for
  retirement isn't obvious from the files themselves

---

## Roadmap Exceptions

The roadmap is unique. Its purpose is to show the whole road at once —
past, present, and future — so that the direction of travel is always
visible. This changes several conventions:

**No separate "Closed Tasks" section.** Closed tasks stay inline within
their phase or section, marked with their closed-task type. Moving them
out would hide the shape of what was tried in each phase.

**Changelog = construction log.** Roadmap changelog entries describe
when sections of road were built and why direction changed, not file
edits. Think: "we tried this approach, it didn't work for these reasons,
we rerouted here." Future sessions reading the changelog should
understand the history of the road itself.

**Stale dates are acceptable.** "Last updated" on a roadmap means the
last time priorities were reconsidered, not the last time any line
changed. Updating it just because a task got struck through is noise.
Update it when the direction of travel actually shifts.

**The guiding question is not evergreen.** The roadmap's Guiding
Question section should reflect current reality. When Boss's situation
changes materially — job status, legal, housing, income — this section
needs a refresh. Stale guiding questions mislead future sessions about
what matters.

---

## Decision Guide: What do I do with this stale thing?

```
Is the content still accurate and in use?
  → Yes: nothing needed.
  → No: continue.

Does it have genuine historical reference value?
  → No: propose deletion (requires Boss approval).
  → Yes: continue.

Is it an entire system, config stack, or toolset?
  → Yes: move to 99BackUps/<system>/ at repo root or S: if accessible.
  → No: continue.

Is it scoped to one subfolder?
  → Yes: mini 99BackUps inside that folder.
  → No: repo-level 99BackUps.

In either case:
  - Add changelog entry to the source document explaining what moved and why.
  - Strike through or mark any inline references in active docs.
  - Do not scrub all mentions — historical context is part of the record.
```

---

## Changelog

### 2026-08-07
- Document created. Prompted by OpenClaw retirement (first real use of repo-level 99BackUps) and a conversation about changelog conventions and roadmap exceptions. Establishes the full lifecycle protocol so future sessions don't have to re-derive it.
