# Schema Skip Reasons

The `charybdis-schema-first` CI check requires every PR that touches
`charybdis/` to also touch `charybdis/schemas/`. If a change genuinely
doesn't need a schema update (e.g. a typo fix in a contract doc, a README
clarification with no wire-format impact), add a one-line entry below in
the same PR. The check accepts any PR that modifies this file as an
override.

Format: `- PR #<number> — <one-line reason>`

---

(no skips recorded yet)
