---
name: briefing
description: On-demand briefing across Gmail, Calendar, and ClickUp. Use when Boss asks for a "briefing", "what's going on", "catch me up", "/briefing", or similar.
---

# Briefing

A point-in-time survey of what's active and what needs attention. Run it
whenever Boss wants a catch-up, not on a fixed schedule.

## Steps

1. **Gmail** (`mcp__*__search_threads` / Gmail MCP)
   - Search unread threads from the last 3-7 days (adjust window based on how
     long it's been since the last briefing — check `logs/activity.md` for the
     last survey date)
   - Flag anything financial (charges, payments received, due dates), security
     alerts (login notifications), and anything addressed personally to Boss
     that looks time-sensitive
   - Skip routine newsletters/job alerts unless something stands out

2. **Calendar** (`mcp__*__list_events`)
   - Next 7-14 days
   - Flag anything with a cost (bills, payments due) or a hard deadline

3. **ClickUp**
   - Check the Forge Fire space (`90173686954`) for tasks with near-term due
     dates or status changes since the last briefing
   - Cross-reference open items from `plans/roadmap.md` — has anything moved?

4. **Synthesize**
   - Group findings by urgency: "needs action", "fyi", "routine/no action"
   - Cross-check against `plans/roadmap.md` Open Branch Blockers — does this
     briefing change any of them?

## Output format

Short, scannable — bullets grouped by urgency, not a wall of text. End with
1-2 sentences on whether anything from this briefing should change the roadmap.

## Notes

- This is read-only by default. Don't draft emails, create calendar events, or
  modify ClickUp tasks unless Boss asks as a follow-up.
- If it's been a long time since the last briefing, say so — don't silently
  widen the search window without noting it.

---

## Changelog

### 2026-08-07
- Removed OpenClaw/Telegram references from description and body; OpenClaw archived to 99BackUps/.
