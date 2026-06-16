---
name: finance-review
description: Finance check-in covering budget status and upcoming bills. Use when Boss asks for a "finance review", "budget check", "/finance-review", or when a new month starts and the monthly budget hasn't been created yet.
---

# Finance Review

Lightweight recurring check, not full bookkeeping. Goal: make sure the monthly
budget exists and flag upcoming bills/income so nothing slips given Boss's
disrupted income situation (Chestnut termination, house sale in progress).

## Steps

1. **Budget status**
   - Check ClickUp Finance space for a budget task/doc for the current month
     (per `logs/activity.md`, budgets have historically been tracked through
     May 2026 — confirm whether June and later months exist)
   - If the current month's budget is missing, flag it as the top item —
     don't create one unilaterally, just surface it

2. **Upcoming bills / due dates**
   - Calendar: scan next 14 days for anything bill-shaped (recurring payments,
     "due" events) — e.g. Commerce CC payment seen previously
   - Gmail: search recent threads for statements, due-date reminders, or
     payment confirmations

3. **Recent income/expense signals**
   - Gmail: scan for payment notifications (PayPal, Cash App, etc.) since the
     last finance review — just note amounts/sources, don't categorize deeply

4. **Cross-check with house sale**
   - If anything in Gmail/Calendar relates to 7707 Murdoch Ave (closing dates,
     offers, paperwork deadlines), surface it — this affects the whole
     financial picture

## Output format

- Budget status: exists / missing for [month]
- Upcoming bills: list with dates/amounts
- Recent income/expense signals: brief list
- House sale: any new developments

## Guardrails

- Read-only — don't create ClickUp tasks/docs or send anything unless Boss
  asks as a follow-up.
- No spending money or initiating payments (per Playbook operating principle).
- If the same gap (e.g. "June budget missing") has been flagged multiple
  sessions running, say so explicitly rather than repeating it as if new.
