---
name: openclaw-fix
description: Walks the OpenClaw recovery checklist from logs/openclaw_errors.md. Use when Boss is on the WSL/tablet machine and ready to fix OpenClaw, or asks "let's fix OpenClaw", "/openclaw-fix", "openclaw recovery".
---

# OpenClaw Recovery Walkthrough

OpenClaw fixes require shell access to Boss's WSL machine, which this repo's
sandbox does not have. This skill turns the static checklist in
`logs/openclaw_errors.md` into a guided walkthrough: Ember proposes the next
command, Boss runs it (on the tablet/WSL) and reports the output, Ember
interprets and proposes the next step.

## Steps

1. Read `logs/openclaw_errors.md` — "Recovery Checklist" section at the bottom,
   plus the individual error entries above it for context on *why* each step
   exists.

2. Walk the checklist **in order**, one step at a time:
   - State the command to run and what a good/bad result looks like
   - Wait for Boss to paste the output
   - If it succeeds, check the box conceptually and move to the next step
   - If it fails, diagnose using the relevant error entry's context before
     proposing a fix — don't just retry blindly

3. Checklist order (from `logs/openclaw_errors.md`):
   1. `systemctl --user status` — verify systemd user session
   2. If broken: `loginctl enable-linger jackr` then `systemctl --user daemon-reexec`
   3. Fix the JSON5 trailing-comma error at `~/.openclaw/openclaw.json:164`
      (also remove the unrecognized `agentRuntime` / `visibleReplies` keys per
      the "Gateway connectivity probe" entry)
   4. `openclaw config schema` — verify config is valid
   5. `npm install -g openclaw@latest`
   6. `openclaw gateway install --force`
   7. `systemctl --user start openclaw-gateway`
   8. Add Telegram bot token to `~/.openclaw/.env`, restart gateway
   9. `openclaw gateway status` — confirm probe passes

4. **When done (fully or partially)**:
   - Update `logs/openclaw_errors.md`: mark resolved steps, update `Status:`
     fields on the relevant error entries, add a new dated entry if a new
     issue was discovered
   - Update `plans/roadmap.md` Open Branch Blockers — remove resolved items
   - Note progress in `logs/activity.md` at session close

## Guardrails

- Never invent command output — only act on what Boss actually reports back.
- If a step reveals a new/different error than documented, treat it as a new
  entry in `logs/openclaw_errors.md`, don't force-fit it into the existing plan.
- This skill doesn't touch Telegram/OpenClaw integration *within Claude* — it's
  purely helping Boss get the external OpenClaw daemon itself running.
