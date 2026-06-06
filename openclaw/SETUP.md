# OpenClaw Setup & Troubleshooting Guide

## Current State

- **Tablet**: OpenClaw installed, but struggling (gateway/daemon issues — see Fixing Tablet below)
- **Phone**: Not connected yet — see Connecting Your Phone via Telegram
- **Goal**: Stable gateway on tablet, Telegram bot accessible from phone

---

## Fixing the Tablet Installation

### Step 1 — Quick diagnostics (run in WSL terminal)

```bash
openclaw gateway status
openclaw doctor --fix
```

`doctor --fix` resolves ~70% of issues automatically. If it passes, skip to Step 4.

### Step 2 — Kill orphaned gateway processes (most common Windows issue)

The Windows Scheduled Task wrapper often leaves an orphaned Node.js process that blocks restarts.

```powershell
# In PowerShell (Windows side):
netstat -ano | findstr :18789
# Note the PID in the last column, then:
taskkill /PID <pid> /F
```

Then back in WSL:
```bash
openclaw gateway restart
openclaw gateway status
```

### Step 3 — Force gateway.mode if still broken

```bash
openclaw config set gateway.mode local
openclaw gateway restart
```

### Step 4 — Check version (upgrade if pre-2026.5.26)

```bash
openclaw --version
# If outdated:
npm install -g openclaw@latest
openclaw gateway restart
```

### Step 5 — Verify config is loaded

```bash
openclaw config schema          # view current live config
openclaw doctor --fix           # re-run after any config edit
```

---

## Connecting Your Phone via Telegram

### Part A — Create a Telegram Bot (5 minutes)

1. Open Telegram on your phone
2. Search for **@BotFather**
3. Send `/newbot`
4. Follow prompts: pick a name and username (e.g. `ForgeFireBot`)
5. BotFather gives you a **bot token** — looks like `123456789:ABCdef...`
6. Copy it into `~/.openclaw/.env` as `TELEGRAM_BOT_TOKEN=...`

### Part B — Get your Telegram user ID

1. In Telegram, search **@userinfobot**
2. Send it any message — it replies with your numeric ID (e.g. `987654321`)
3. Note this ID for the next step

### Part C — Update OpenClaw config

Edit `~/.openclaw/openclaw.json`:

```json5
channels: {
  telegram: {
    enabled: true,
    botToken: "${TELEGRAM_BOT_TOKEN}",
    dmPolicy: "pairing",   // keep as pairing for first message
  }
}
```

Then restart:
```bash
openclaw gateway restart
```

### Part D — Pair your phone

1. Open Telegram on your phone
2. Find your new bot by its username (e.g. `@ForgeFireBot`)
3. Send it any message
4. OpenClaw will reply with a **pairing code** — enter it back in the chat
5. You're paired. Done.

### Part E — Lock down to your user ID only (recommended)

After pairing, update `openclaw.json`:

```json5
channels: {
  telegram: {
    dmPolicy: "allowlist",
    allowFrom: ["tg:987654321"]   // your Telegram user ID from Part B
  }
}
```

```bash
openclaw gateway restart
```

---

## Daily Use

Once running, you can message OpenClaw (→ Claude) from Telegram anytime:

```
Hey, what's on my calendar today?
What tasks are open in Forge Fire?
Send me my morning briefing
```

OpenClaw will respond in Telegram using Claude as the brain.

---

## Auto-Start at Windows Boot (WSL)

To ensure OpenClaw survives reboots, run once in WSL:

```bash
sudo loginctl enable-linger "$(whoami)"
openclaw gateway install
```

Then create a Windows Scheduled Task to start WSL at boot:
- Action: `wsl.exe -e bash -c "openclaw gateway start"`
- Trigger: At system startup
- Run whether user is logged on or not

---

## Quick Reference

| Command | What it does |
|---------|-------------|
| `openclaw gateway status` | Check if gateway is running |
| `openclaw gateway restart` | Restart (kills orphans first) |
| `openclaw doctor --fix` | Auto-repair config/process issues |
| `openclaw config schema` | View all current config values |
| `openclaw --version` | Check installed version |
