---
name: research-compare
description: General-purpose comparison research for any topic with multiple options and fewer decisions than options. Use when Boss asks to compare tools/services/approaches ("/research-compare <topic>", "what are the alternatives to X", "compare options for Y") — produces a structured table and surfaces open questions instead of picking a winner.
---

# Research Compare

Web-search-driven comparison for decisions Ember shouldn't make unilaterally
(which tool to adopt, which service to pay for, which approach to commit to)
but can usefully scope down for Boss.

## Inputs

Takes a topic plus optional constraints (e.g. "alternatives to OpenClaw,
must run on Windows/WSL, must support Telegram"). If Boss gives a bare topic
with no constraints, proceed anyway and note the lack of constraints as an
open question rather than inventing requirements.

## Steps

1. **Search** — run 2-3 web searches covering: the direct "alternatives to X"
   angle, and a broader landscape angle (e.g. "best <category> tools <year>")
   so single-source bias doesn't drive the whole comparison.
2. **Sanity-check the results before trusting them.** Some niches (anything
   adjacent to a trending tool name) attract SEO spam and lookalike branding —
   watch for: names that pattern-match the original tool suspiciously closely,
   suspiciously fast/round growth claims ("12,000 stars in a week"), and blog
   posts with no verifiable primary source (no GitHub link, no changelog).
   If search results look spammy, say so explicitly in the output rather than
   presenting them as verified fact — recommend the human (or a session with
   repo/browser access) verify firsthand before any install/adoption decision.
3. **Build a comparison table**: one row per option, columns for what it does,
   cost, platform support, complexity to adopt, community/credibility signal
   (and whether that signal is verified or just claimed), top pro, top con.
4. **Rank by fit, don't declare a winner.** Order options loosely by how well
   they match the stated constraints, but the final call belongs to Boss —
   say what you'd lean toward and why, not what to do.
5. **List open questions** — anything that changes the ranking depending on
   an answer only Boss has (budget, hard platform requirements, risk
   tolerance, whether this is replacing something or running in parallel).
6. **Save output** to `plans/research/<topic-slug>.md` (kebab-case topic name).
   Log the research in `logs/activity.md` (newest-first position) and update
   the relevant roadmap item's status if one exists.

## Output format

The saved file should contain, in order: date + one-line purpose, a
confidence/caveat note if the search results warranted one, the comparison
table, a ranking paragraph (not a verdict), an open-questions checklist for
Boss, and a Sources list with markdown links to everything cited.
