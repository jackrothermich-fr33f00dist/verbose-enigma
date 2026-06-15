---
name: charybdis-checkin
description: Charybdis/WitnessVault evidence pipeline check-in. Use when Boss asks about "Charybdis", "WitnessVault", "evidence", "/charybdis-checkin", or periodically to make sure new evidence is being logged before it goes stale.
---

# Charybdis / WitnessVault Check-In

Charybdis is Boss's evidence-custody pipeline (Phone A/V → WhisperBOT →
SigilForge → OrcaVault → SuperDiskie → Jarvis), tied to an active legal/
grievance process. The pipeline scope and contracts are documented in
`charybdis/` (see `charybdis/README.md`) — purpose/urgency beyond "legal
evidence" is still unconfirmed with Boss.

## Steps

1. **Check for new evidence**
   - Ask Boss directly (or check ClickUp task `86e1mmfdj`) whether any new
     audio/video/documents have been captured since the last check-in that
     need to enter the pipeline
   - Evidence fades in value the longer it sits unprocessed/uncatalogued —
     the point of this check-in is to catch that early

2. **Review contract status**
   - `charybdis/` contains four draft contracts (WhisperBOT handoff, processed
     vault manifest, SigilForge bundle input, OrcaVault drop receipt)
   - Confirm with Boss whether these have been reviewed/copied to the D: drive
     canonical project (`D:\02Domains\04Growth_Rings\01Charybdis\04WitnessVault_Project`)
   - If still pending, that's a carry-forward item, not a new one

3. **Open question: purpose/urgency**
   - This has been an open question across multiple sessions
     (`plans/roadmap.md` Open Questions). Don't re-ask passively — if Boss is
     present, ask directly once. If answered, record it in `Ember_Playbook.md`
     or `plans/roadmap.md` and remove it from Open Questions.

4. **custody_id integrity**
   - If discussing specific evidence items, remember `custody_id` is the
     immutable thread linking a piece of evidence across every pipeline stage
     (raw → processed → encrypted → dropped). Don't suggest workflows that
     would break or reassign it.

## Guardrails

- No project movement, folder renaming, or repo rerouting without Boss's
  explicit approval (per `plans/roadmap.md` 2A guardrail).
- This is a check-in, not a processing run — don't attempt to actually move
  evidence through the pipeline stages from this repo.
