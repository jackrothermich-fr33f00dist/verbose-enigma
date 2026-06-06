# Charybdis / WitnessVault — Working Drafts

Working documents drafted by Ember. These are **proposals** — review and copy to the canonical D: drive project path before treating as authoritative.

Canonical path: `D:\02Domains\04Growth_Rings\01Charybdis\04WitnessVault_Project`

## What's here

| File | Purpose |
|------|---------|
| `processed_vault_manifest_schema.md` | Schema for a processed (post-WhisperBOT) evidence record |
| `whisperbot_handoff_contract.md` | What WitnessVault sends to WhisperBOT; what it gets back |
| `sigilforge_bundle_input_contract.md` | What the WhisperBOT output passes to SigilForge for encryption |
| `orcavault_drop_receipt_contract.md` | Receipt schema after OrcaVault drops a bundle to SuperDiskie |

## Pipeline at a glance

```
Phone A/V
   ↓
Raw Intake (convention already defined)
   ↓
Raw Custody Manifest (schema already defined)
   ↓
WhisperBOT (handoff contract → this repo)
   ↓
Processed Vault Manifest (schema → this repo)
   ↓
SigilForge (bundle input contract → this repo)
   ↓
OrcaVault bundle
   ↓
SuperDiskie drop + Drop Receipt (schema → this repo)
   ↓
Jarvis review
```

## ClickUp task

`86e1mmfdj` — [WitnessVault] Charybdis evidence custody pipeline
