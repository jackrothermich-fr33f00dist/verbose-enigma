# Processed Vault Manifest Schema

**Status**: Draft — Ember, 2026-06-06. Copy to D: drive for canonical use.

Defines the schema for a processed evidence record — a raw file that has been through WhisperBOT and is ready for SigilForge encryption. Extends the raw custody manifest with processing metadata.

---

## Schema (JSON)

```json
{
  "schema_version": "1.0",
  "manifest_type": "processed_vault",

  "identity": {
    "custody_id": "<matches original raw custody manifest id — never changes>",
    "processed_manifest_id": "<uuid-v4, unique to this processed record>",
    "created_at": "<ISO 8601 UTC — when this processed record was created>",
    "case_id": "<Charybdis case identifier>"
  },

  "raw_file": {
    "path": "<absolute path to original raw A/V file>",
    "filename": "<original filename>",
    "sha256": "<hex — must match raw custody manifest>",
    "size_bytes": "<integer>",
    "intake_timestamp": "<ISO 8601 UTC — when file was originally ingested>"
  },

  "whisperbot": {
    "handoff_id": "<matches WhisperBOT handoff_id>",
    "processed_at": "<ISO 8601 UTC>",
    "model_used": "<e.g. whisper-large-v3>",
    "status": "success | partial | failed",
    "error": "<null or error string>"
  },

  "transcript": {
    "path": "<absolute path to transcript file>",
    "sha256": "<hex>",
    "word_count": "<integer>",
    "format": "txt | vtt | srt | json",
    "confidence_overall": "<float 0.0–1.0 or null>",
    "low_confidence_segments": "<integer>"
  },

  "diarization": {
    "available": true,
    "speaker_count": "<integer or null>",
    "path": "<absolute path to diarization JSON, or null>"
  },

  "event_metadata": {
    "event_date": "<YYYY-MM-DD>",
    "location": "<free text, optional>",
    "description": "<free text>",
    "parties": ["<name or role>"],
    "sensitivity": "standard | confidential | privileged"
  },

  "artifacts": [
    {
      "type": "raw_audio | raw_video | transcript | diarization | summary | other",
      "filename": "<filename>",
      "path": "<absolute path>",
      "sha256": "<hex>",
      "size_bytes": "<integer>"
    }
  ],

  "chain_of_custody": [
    {
      "timestamp": "<ISO 8601 UTC>",
      "actor": "<system or person>",
      "action": "ingested | processed | flagged | reviewed | encrypted | dropped | other",
      "note": "<optional free text>"
    }
  ],

  "review": {
    "reviewed_by": "<name or null if not yet reviewed>",
    "reviewed_at": "<ISO 8601 UTC or null>",
    "review_notes": "<free text or null>",
    "ready_for_encryption": true
  },

  "sigilforge": {
    "status": "pending | submitted | complete | failed",
    "submitted_at": "<ISO 8601 UTC or null>",
    "bundle_id": "<SigilForge bundle ID or null>"
  }
}
```

---

## File naming convention

```
<custody_id>--processed_manifest.json
```

Example: `CHX-2026-001-0003--processed_manifest.json`

---

## Lifecycle state transitions

```
raw_ingested
   → whisperbot_queued
   → whisperbot_processing
   → whisperbot_done (success | partial | failed)
   → ready_for_encryption   ← requires human review if sensitivity = privileged
   → sigilforge_submitted
   → encrypted_and_bundled
```

---

## Notes

- `custody_id` is immutable across the entire pipeline. It links raw custody → processed → encrypted bundle → drop receipt.
- `chain_of_custody` is append-only. Never remove entries.
- If `sensitivity = "privileged"`, the `review.reviewed_by` field must be populated before `ready_for_encryption` is set to `true`.
