# WhisperBOT Handoff Contract

**Status**: Draft — Ember, 2026-06-06. Copy to D: drive for canonical use.

Defines what WitnessVault passes to WhisperBOT for transcription/processing, and what WhisperBOT returns.

---

## Input: WitnessVault → WhisperBOT

WitnessVault writes a **handoff manifest** file alongside the raw A/V file. WhisperBOT reads both.

### Handoff manifest schema (JSON)

```json
{
  "schema_version": "1.0",
  "handoff_id": "<uuid-v4>",
  "custody_id": "<matches raw custody manifest id>",
  "submitted_at": "<ISO 8601 UTC>",
  "submitted_by": "WitnessVault",

  "source_file": {
    "path": "<absolute path to raw A/V file>",
    "filename": "<original filename>",
    "sha256": "<hex hash of raw file>",
    "size_bytes": "<integer>",
    "duration_seconds": "<float or null if unknown>",
    "media_type": "audio | video",
    "format": "mp4 | m4a | wav | mp3 | ogg | webm | other"
  },

  "context": {
    "case_id": "<Charybdis case identifier, e.g. CHX-2026-001>",
    "event_date": "<YYYY-MM-DD — date of the recorded event, not intake date>",
    "location": "<free text, optional>",
    "description": "<free text summary of what this recording captures>",
    "parties": ["<name or role of people present, optional>"],
    "sensitivity": "standard | confidential | privileged"
  },

  "processing_instructions": {
    "transcribe": true,
    "diarize": true,
    "language": "en",
    "model_preference": "whisper-large | auto",
    "redact_pii": false,
    "notes": "<any special instructions for WhisperBOT>"
  }
}
```

### File naming convention

```
<custody_id>--handoff.json
```

Example: `CHX-2026-001-0003--handoff.json`

---

## Output: WhisperBOT → WitnessVault

WhisperBOT writes a **processing result** file to an agreed output drop path.

### Processing result schema (JSON)

```json
{
  "schema_version": "1.0",
  "handoff_id": "<matches input handoff_id>",
  "custody_id": "<matches input custody_id>",
  "processed_at": "<ISO 8601 UTC>",
  "processed_by": "WhisperBOT",
  "model_used": "<e.g. whisper-large-v3>",

  "status": "success | partial | failed",
  "error": "<error message if status is failed or partial, else null>",

  "transcript": {
    "path": "<path to .txt or .vtt transcript file>",
    "format": "txt | vtt | srt | json",
    "word_count": "<integer>",
    "sha256": "<hex hash of transcript file>"
  },

  "diarization": {
    "available": true,
    "speaker_count": "<integer or null>",
    "path": "<path to diarization JSON file, or null>"
  },

  "confidence": {
    "overall": "<float 0.0–1.0 or null>",
    "low_confidence_segments": "<integer count of flagged segments>"
  },

  "artifacts": [
    {
      "type": "transcript | diarization | summary | other",
      "path": "<absolute path>",
      "sha256": "<hex>"
    }
  ]
}
```

### File naming convention

```
<custody_id>--whisperbot_result.json
```

---

## Drop paths (to be confirmed by Boss)

| Direction | Path |
|-----------|------|
| WitnessVault → WhisperBOT (input drop) | `D:\02Domains\04Growth_Rings\01Charybdis\04WitnessVault_Project\03WhisperBOT_Queue\` |
| WhisperBOT → WitnessVault (result drop) | `D:\02Domains\04Growth_Rings\01Charybdis\04WitnessVault_Project\04Processed_Vault\` |

---

## Error handling

- If WhisperBOT fails, it writes `status: "failed"` and a non-null `error` in the result file. WitnessVault surfaces this for manual review.
- Partial transcripts (`status: "partial"`) are retained but flagged in the processed vault manifest.
- WhisperBOT must never modify or delete the original raw A/V file.
