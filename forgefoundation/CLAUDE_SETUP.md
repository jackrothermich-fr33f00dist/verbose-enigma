# ForgeFoundation — Claude Code Setup

ForgeFoundation is Boss's renamed local copy (SuperDiskie, `Entities/Fordrasil's Trunk/Skills/01Skills`)
of the public [`addyosmani/agent-skills`](https://github.com/addyosmani/agent-skills) Claude Code
plugin marketplace — a software dev-lifecycle framework: `/spec → /plan → /build → /test → /review → /ship`,
4 agent personas (code-reviewer, test-engineer, security-auditor, web-performance-auditor), and a
SessionStart hook.

## Global Install (from SuperDiskie)

Boss's preferred source is the local copy on SuperDiskie, not GitHub — the marketplace files
live in the `01Skills` folder on the SuperDiskie drive (mounted as E: on some machines, a
different drive letter or `/mnt/...` path on others). Run this once per machine, in any Claude
Code session, pointing at wherever SuperDiskie's `01Skills` folder is mounted on *that* machine
(it writes to that machine's `~/.claude/settings.json`, so it applies to every project on that
machine):

```
/plugin marketplace add "<path-to-SuperDiskie>/01Skills"
/plugin install agent-skills@addy-agent-skills
```

This adds:

```json
{ "enabledPlugins": { "agent-skills@addy-agent-skills": true } }
```

to `~/.claude/settings.json`, plus the marketplace registration. After install, `/spec`, `/plan`,
`/build`, `/test`, `/review`, `/code-simplify`, `/ship` and the four agent personas are available
in every project on that machine.

**Note**: local-path marketplaces don't auto-update via `/plugin marketplace update` — but since
SuperDiskie is the shared physical copy, any edits Boss makes to `01Skills` on one machine are
picked up by every other machine the next time it reads from the drive (no separate sync step
needed). The GitHub source (`addyosmani/agent-skills`) remains a fallback if SuperDiskie isn't
available on a given machine:

```
/plugin marketplace add addyosmani/agent-skills
/plugin install agent-skills@addy-agent-skills
```

## Per-Project Kill Switch

Settings precedence is `user < project < local`. Any repo can opt out of ForgeFoundation
regardless of the global install by adding to that repo's `.claude/settings.json` (team-wide,
checked in) or `.claude/settings.local.json` (personal, gitignored):

```json
{ "enabledPlugins": { "agent-skills@addy-agent-skills": false } }
```

## Where It Fits

ForgeFoundation's `/spec → /build → /ship` lifecycle gates are built for shipping code features.
Repos like `verbose-enigma` (ops/memory, not a product codebase) opt out — see its
`.claude/settings.json` for the kill switch in practice. Install it where Forge Fire builds
actual software (WhisperBOT, Growth Rings tooling, dashboards, etc.).

## Open Question

Boss raised the idea of a `UserPromptSubmit` hook that pings ForgeFoundation as a quality-gate
check on every turn. The upstream plugin has no such hook — it would be custom-built, and would
add latency to every prompt. Not yet implemented; revisit if/when it's needed for an active
product repo.
