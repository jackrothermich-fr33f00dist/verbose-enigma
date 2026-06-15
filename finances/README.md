# Finance Data Staging

`2025_transactions_jul_oct.csv` — consolidated personal transaction data for
July-October 2025, transcribed from the Google Drive "2025 Budgets" monthly
workbooks (07JUL2025/Worse july.xlsx, 08 AUG2025.xlsx, 09SEPT2025.xlsx,
10OCT2025.xlsx).

Unified schema: `date, time, amount, recipient, location, description,
category, subcategory, funding_source, source_month`.

Source files had inconsistent schemas (missing Location/Funding Source
columns, `$` prefixes, Noted/Accounted flags) — normalized here. `category`
and `subcategory` retain the original numeric legend codes (e.g. `4:1`,
`5:2`) used in the source workbooks; the legend itself wasn't transcribed.

Purpose: staging file for manual import into the Discreet Ledger app
(orcav.io/ledger), since direct API/repo access to `expense_tracker` is
outside this session's scope.

Not yet covered: Nov/Dec 2025 budgets, and the older/duplicate "2025 Budgets"
Drive folder (relationship to this one is unclear, flagged in
`00Overview--2025_Budgets.md` on Drive).
