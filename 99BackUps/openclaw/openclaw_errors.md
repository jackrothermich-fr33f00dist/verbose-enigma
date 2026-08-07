# OpenClaw Setup — Error & Troubleshooting Log

Persisting record of issues encountered during OpenClaw setup. Newest entries first.

---

## 2026-06-04 — WSL systemd user session failure

**Error:**
```
wsl: Failed to start the systemd user session for 'jackr'. See journalctl for more details.
```

**Context:** Followed a full WSL shutdown (`wsl --shutdown`) after discovering WSL's ext4.vhdx lives on D: drive (SuperDiskie). D: was briefly inaccessible, causing cascading I/O errors on all WSL binaries mid-session. WSL restarted but systemd user session failed.

**Impact:** `systemctl --user` won't work. OpenClaw's systemd service won't auto-start. Cannot use `openclaw gateway install/start` via systemd.

**Diagnosis steps when ready:**
```bash
journalctl --user -n 50 --no-pager
systemctl --user status
```

**Status:** Unresolved — deferred. Boss stepped away.

---

## 2026-06-04 — openclaw.json syntax error introduced by nano edit

**Error:**
```
JSON5: invalid character ',' at 164:4
```

**Context:** Attempted to remove the two invalid config keys (`agentRuntime` under openai/gpt-5.5, `visibleReplies` under messages.groupChat) via nano. Deletion left a trailing comma at line 164, breaking the JSON5 parse.

**Impact:** All openclaw CLI commands fail immediately. Gateway cannot start.

**Fix:** Need to view/edit lines ~155-175 of `~/.openclaw/openclaw.json` and remove the dangling comma. Once WSL is stable, run:
```bash
python3 -c "
lines = open('/home/jackr/.openclaw/openclaw.json').readlines()
for i, l in enumerate(lines[152:175], 153):
    print(f'{i}: {l}', end='')
"
```
Then remove the offending comma and save.

**Status:** Unresolved — blocked by WSL systemd issue above.

---

## 2026-06-04 — D: drive (SuperDiskie) WSL disk path error

**Error:**
```
Failed to attach disk 'D:\00System\04Environment\WSL\Ubuntu-Restored\ext4.vhdx' to WSL2: 
The system cannot find the path specified.
Error code: Wsl/Service/CreateInstance/MountDisk/HCS/ERROR_PATH_NOT_FOUND
```

**Context:** WSL VHD lives on D: drive. D: briefly went offline (see Codex Playbook backup note from 2026-05-06: "D: unavailable in PowerShell"). This caused all running WSL binaries to throw I/O errors mid-session.

**Resolution:** D: came back online. WSL restarted but with systemd failure (see above).

**Prevention note:** WSL VHD on removable/conditional drive is fragile. Consider migrating ext4.vhdx to C: drive for stability, or ensuring D: always mounts before WSL starts.

---

## 2026-06-04 — Gateway connectivity probe: protocol mismatch (persistent)

**Error:**
```
Connectivity probe: failed — protocol mismatch
```
**Also:** Config validation warnings:
```
agents.defaults.models.openai/gpt-5.5: Unrecognized key: "agentRuntime"
messages.groupChat: Unrecognized key: "visibleReplies"
```
**Also:** Service args hardcode `--port 18789 bind=loopback` overriding config.

**Context:** Running OpenClaw 2026.4.26 (outdated — latest is 2026.5.26). Gateway runs as systemd service but connectivity probe fails. Root causes: invalid config keys + outdated version.

**Planned fix (not yet executed):**
1. Fix JSON syntax error (see above)
2. Remove `agentRuntime` and `visibleReplies` keys
3. `openclaw gateway install --force` to regenerate service file
4. Upgrade to latest: `npm install -g openclaw@latest`
5. Add Telegram bot token to config
6. Restart gateway

**Status:** Blocked by systemd session failure + JSON syntax error.

---

## Recovery Checklist (run in order when WSL is stable)

- [ ] Verify systemd user session: `systemctl --user status`
- [ ] If systemd broken: `loginctl enable-linger jackr` then `systemctl --user daemon-reexec`
- [ ] Fix openclaw.json syntax error (trailing comma at line 164)
- [ ] Verify config valid: `openclaw config schema`
- [ ] Upgrade OpenClaw: `npm install -g openclaw@latest`
- [ ] `openclaw gateway install --force`
- [ ] `systemctl --user start openclaw-gateway`
- [ ] Add Telegram bot token, restart
- [ ] `openclaw gateway status` — confirm probe passes
