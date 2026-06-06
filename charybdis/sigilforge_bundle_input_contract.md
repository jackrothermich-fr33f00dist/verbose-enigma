# SigilForge Bundle Input Contract

**Status**: Draft — Ember, 2026-06-06. Copy to D: drive for canonical use.

Defines what WitnessVault submits to SigilForge for encryption and bundling, and what SigilForge produces.

---

## Input: WitnessVault → SigilForge

When a processed manifest is marked `ready_for_encryption: true`, WitnessVault submits a **bundle request** to SigilForge.

### Bundle request schema (JSON)

```json
{
  "schema_version": "1.0",
  "request_id": "<uuid-v4>",
  "submitted_at": "<ISO 8601 UTC>",
  "submitted_by": "WitnessVault",

  "identity": {
    "custody_id": "<immutable chain ID>",
    "processed_manifest_id": "<matches processed vault manifest>",
    "case_id": "<Charybdis case identifier>"
  },

  "files": [
    {
      "role": "raw_audio | raw_video | transcript | diarization | manifest | other",
      "path": "<absolute path>",
      "filename": "<filename>",
      "sha256": "<hex — SigilForge verifies before encrypting>",
      "size_bytes": "<integer>",
      "include_in_bundle": true
    }
  ],

  "encryption": {
    "algorithm": "AES-256-GCM",
    "key_source": "sigilforge_managed | provided",
    "key_id": "<SigilForge key ID or null if managed>",
    "recipients": [
      {
        "name": "<recipient name>",
        "key_fingerprint": "<PGP fingerprint or null>"
      }
    ]
  },

  "bundle": {
    "format": "zip+gpg | tar.gz+gpg | custom",
    "include_manifest": true,
    "include_chain_of_custody": true,
    "output_path": "<where SigilForge should write the encrypted bundle>"
  },

  "metadata": {
    "sensitivity": "standard | confidential | privileged",
    "event_date": "<YYYY-MM-DD>",
    "description": "<human-readable summary for bundle label>"
  }
}
```

### File naming convention for bundle request

```
<custody_id>--sigilforge_request.json
```

---

## Output: SigilForge → WitnessVault

SigilForge writes a **bundle receipt** after successful encryption.

### Bundle receipt schema (JSON)

```json
{
  "schema_version": "1.0",
  "request_id": "<matches input request_id>",
  "bundle_id": "<SigilForge-assigned bundle ID>",
  "completed_at": "<ISO 8601 UTC>",

  "identity": {
    "custody_id": "<matches input>",
    "case_id": "<matches input>"
  },

  "status": "success | failed",
  "error": "<null or error string>",

  "bundle": {
    "path": "<absolute path to encrypted bundle file>",
    "filename": "<bundle filename>",
    "sha256": "<hex of encrypted bundle>",
    "size_bytes": "<integer>",
    "format": "zip+gpg | tar.gz+gpg | custom"
  },

  "encryption": {
    "algorithm": "AES-256-GCM",
    "key_id": "<key ID used>",
    "recipients": ["<recipient names>"]
  },

  "files_included": [
    {
      "role": "<matches input role>",
      "filename": "<filename>",
      "sha256_pre_encryption": "<hex — verifies integrity of input>"
    }
  ],

  "verification": {
    "bundle_sha256_confirmed": true,
    "all_input_hashes_verified": true
  }
}
```

### File naming convention for bundle receipt

```
<custody_id>--sigilforge_receipt.json
```

---

## Error handling

- SigilForge must write a receipt with `status: "failed"` even on failure — never silently drop a request.
- Hash mismatch on any input file: abort and report `error: "hash_mismatch:<filename>"`.
- SigilForge must not delete source files after bundling — WitnessVault controls source file lifecycle.
- Encryption key must be verifiable by Jarvis at review time.
