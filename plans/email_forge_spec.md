# Email Forge — Gmail Triage Spec

Spec for the Athanor/Codex "Email Forge" tasks (ClickUp space `Athanor / Codex Operations`).
Drafted by Ember from a live retroactive triage pass on 2026-06-10. This documents the
rules used in that pass and the additional automation Athanor should build (filters,
forwarding, scheduled labeling) that requires deeper Gmail API access than the
session MCP toolkit provides.

## Existing label taxonomy (already in Gmail, do not duplicate)

- Work
- Chesterfield Service/Homecare
- Notes
- Reach Completion Goal
- Government & News
- Events & Conferences
- Entertainment & Hobbies
- Banking & Accounts
- CHEARR
- Information & Newsletters
- Legal Documents
- Job Alerts
- DnD / DnD/Kickstarter Confirmations
- Health & Wellness
- aProfessional Development
- Shopping & Rewards
- Personal & Calendar
- Transactions & Bills
- Urgent/Follow Up
- Unsubscribe

## New label proposed

- **Charybdis** — for case-number detection / legal evidence routing (2A in roadmap).
  Not yet created. Recommend Athanor create this and route any email matching
  case-number patterns or known Charybdis correspondents here, in addition to
  `Legal Documents`.

## Triage rules used in the 2026-06-10 retroactive pass

Sender/subject pattern → label(s):

| Pattern | Label(s) |
|---|---|
| `cs.amwater.com`, any "payment due" / bill reminder | Transactions & Bills + Urgent/Follow Up |
| `email.monarch.com` (transaction review) | Transactions & Bills |
| `e.godaddy.com` account summary | Transactions & Bills |
| `notifications.cash.app` (trade/transaction confirmations) | Banking & Accounts |
| `s.usa.experian.com` | Banking & Accounts |
| `notifications@github.com` re: own repos (CI failures, PR comments, PAT alerts) | Work (+ Urgent/Follow Up if a workflow run failed) |
| `accounts.google.com` security alerts | Urgent/Follow Up (verify, then can be archived) |
| `jobalerts-noreply@linkedin.com`, application status emails (e.g. UKG) | Job Alerts |
| `invitations@linkedin.com`, `notifications-noreply@linkedin.com`, LinkedIn newsletters | aProfessional Development |
| LinkedIn birthday/social nudges | Personal & Calendar |
| `s.backerkit.com`, Kickstarter project updates | Entertainment & Hobbies |
| `riverside.fm`, Medium digests, `MyClaw@aisecret.us`, MarkTechPost, `consensus.app`, `email.claude.com`, `ship.emergent.sh`, Pocket, Chaos Control / Tarasov | Information & Newsletters |
| `betterhelp.com`, `labcorpmessage.com` | Health & Wellness |
| Calendar invites from unknown senders (e.g. court dates) | Personal & Calendar (+ flag for manual calendar review) |
| `dmarc.public.govdelivery.com` (state/local gov bulletins) | Government & News |
| Walgreens, Fetch, Schnucks rewards/marketing | Shopping & Rewards |
| Casino/sweepstakes spam (`gener8ads.com`), misdirected newsletters (e.g. Cottey College "Dear Phil") | Unsubscribe |

## Automation Athanor should build (requires fuller Gmail API access)

1. **Gmail Filters** (not available via session MCP — `create_filter` API or Apps Script):
   - Auto-apply the table above as real Gmail filters so new mail is labeled on arrival.
   - Auto-archive low-value categories (Shopping & Rewards, most Information & Newsletters)
     out of inbox while keeping the label.

2. **VIP notification routing**
   - Define VIP sender list (legal contacts, Boss's bank, known clients).
   - Any VIP sender → `Urgent/Follow Up` + push notification via OpenClaw/Telegram once connected.

3. **Case-number detection and Charybdis routing**
   - Regex scan subject/body for case-number patterns (format TBD — ask Boss for examples).
   - Match → label `Charybdis` + `Legal Documents`, and append to a running index file
     in `charybdis/` for custody tracking.

4. **Email-to-task extraction**
   - Bills/payment-due emails → auto-create ClickUp task in Finance list with due date
     parsed from email body (e.g. American Water "due in 5 days" → due date task).

5. **Waiting-too-long escalation**
   - Threads labeled `Urgent/Follow Up` with no reply/label change after N days →
     surface in daily briefing.

## Open questions for Boss

- Confirm Charybdis case-number format so detection regex can be built.
- Confirm whether Google security alerts (new sign-ins) are expected — multiple
  appeared this week, may just be session logins from this agent environment.
- VIP sender list — who should trigger immediate notification?
