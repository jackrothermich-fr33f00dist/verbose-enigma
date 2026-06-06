# OrcaVault / SuperDiskie Drop Receipt Contract

**Status**: Draft — Ember, 2026-06-06. Copy to D: drive for canonical use.

Defines the receipt schema written after OrcaVault successfully drops an encrypted bundle to SuperDiskie, and what Jarvis needs to verify the drop.

---

## What OrcaVault does

OrcaVault takes a SigilForge-encrypted bundle and:
1. Moves/copies it to the designated SuperDiskie drop path
2. Verifies the copy succeeded (hash check)
3. Writes a drop receipt confirming the drop

---

## Drop receipt schema (JSON)

```json
{
  "schema_version": "1.0",
  "receipt_id": "<uuid-v4>",
  "dropped_at": "<ISO 8601 UTC>",
  "dropped_by": "OrcaVault",

  "identity": {
    "custody_id": "<immutable chain ID>",
    "bundle_id": "<SigilForge bundle ID>",
    "case_id": "<Charybdis case identifier>"
  },

  "status": "success | failed | partial",
  "error": "<null or error string>",

  "source": {
    "path": "<path of encrypted bundle before drop>",
    "sha256": "<hex — must match SigilForge receipt>",
    "size_bytes": "<integer>"
  },

  "destination": {
    "drive": "SuperDiskie",
    "path": "<absolute path to final bundle location on SuperDiskie>",
    "filename": "<filename at destination>",
    "sha256_verified": true,
    "sha256": "<hex — verified after copy; must match source>"
  },

  "retention": {
    "delete_source_after_drop": false,
    "source_deleted": false,
    "source_deletion_timestamp": null
  },

  "jarvis_ready": {
    "ready": true,
    "review_path": "<path Jarvis should open for review>",
    "manifest_path": "<path to processed_manifest JSON for this record>",
    "chain_of_custody_complete": true
  },

  "notifications": {
    "notify_jarvis": true,
    "notification_sent_at": "<ISO 8601 UTC or null>",
    "notification_method": "telegram | file_flag | clickup | none"
  }
}
```

### File naming convention

```
<custody_id>--drop_receipt.json
```

Example: `CHX-2026-001-0003--drop_receipt.json`

Drop receipts live in: `D:\02Domains\04Growth_Rings\01Charybdis\04WitnessVault_Project\05Drop_Receipts\`

---

## SuperDiskie drop path convention

```
<SuperDiskie root>\WitnessVault\<case_id>\<YYYY-MM>\<custody_id>--bundle.<ext>
```

Example: `E:\WitnessVault\CHX-2026-001\2026-06\CHX-2026-001-0003--bundle.zip.gpg`

---

## Jarvis review checklist (generated from receipt)

Jarvis should verify the following on each drop:

- [ ] `source.sha256` matches `destination.sha256` (copy integrity)
- [ ] `destination.sha256` matches `bundle.sha256` in SigilForge receipt (chain integrity)
- [ ] `chain_of_custody_complete: true`
- [ ] `retention.source_deleted: false` (source preserved)
- [ ] `jarvis_ready.ready: true`
- [ ] Review transcript at `jarvis_ready.review_path`
- [ ] Mark `reviewed_by` and `reviewed_at` in processed vault manifest

---

## Full chain-of-custody trail (per record)

| Stage | File |
|-------|------|
| Raw intake | `<custody_id>--raw_manifest.json` |
| WhisperBOT handoff | `<custody_id>--handoff.json` |
| WhisperBOT result | `<custody_id>--whisperbot_result.json` |
| Processed manifest | `<custody_id>--processed_manifest.json` |
| SigilForge request | `<custody_id>--sigilforge_request.json` |
| SigilForge receipt | `<custody_id>--sigilforge_receipt.json` |
| Drop receipt | `<custody_id>--drop_receipt.json` |

Every file carries the same `custody_id` — this is the immutable thread linking the full chain.
