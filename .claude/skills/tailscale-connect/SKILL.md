---
name: tailscale-connect
description: Connect the current environment (an ephemeral cloud container OR a local machine) to the user's Tailscale tailnet so Claude can reach private tailnet resources — e.g. the S:/Super_Diskie skills-and-knowledge library served on the tailnet. Use when the user asks Claude to join their Tailscale network, mount/reach S: or Super_Diskie, or access a private *.ts.net service. Requires an ephemeral, tagged Tailscale auth key that the user provides at runtime.
---

# /tailscale-connect

Join the user's Tailscale tailnet from wherever this Claude is running, then read
their private `Super_Diskie` library over the tailnet. Works from a locked-down
cloud container (verified: Tailscale routes through the session's HTTPS proxy via
DERP-over-443) and from a local machine (usually already connected — detect and skip).

## ⛔ Security boundary — read first

- **Only ever use an auth key the user explicitly hands you, for a tailnet they own.**
  Joining a private network is a real boundary; never fabricate, reuse a stored, or
  guess a key. If you don't have one, ask.
- **Treat the key as a live secret.** Use it in-memory only. NEVER write it to a file,
  commit it, echo it into logs, or put it in a commit message / PR. `scripts/ts-connect.sh`
  reads it from the `TS_AUTHKEY` env var and unsets it immediately after use.
- **Insist on an *ephemeral*, *tagged* key** (e.g. `tag:claude-tmp`). Ephemeral =
  the node auto-removes when the process dies (perfect for throwaway containers).
  Tagged = the user's ACLs can restrict this node to *only* the Super_Diskie host/port
  instead of the whole tailnet.
- **Tell the user to revoke the key** in the Tailscale admin console after the session.

## When NOT to use this
- If durable/repeated access is needed for the **agent itself** (GitHub Actions runs),
  prefer the CI route: the `tailscale/github-action` with a Tailscale OAuth client stored
  as a repo secret. That survives across sessions; this skill is per-session.

## Procedure

### 0. Detect existing connection (local machines usually pass here)

```bash
tailscale status 2>/dev/null | head -3 && echo "ALREADY CONNECTED" 
```

If already connected, skip straight to **Step 5 (Access)**.

### 1. Preflight (cloud container)

```bash
id -u                                   # need 0 (root) to install + start the daemon
ls -l /dev/net/tun                      # present -> kernel mode; absent -> userspace fallback
grep CapEff /proc/self/status           # want CAP_NET_ADMIN for kernel mode
curl -sS -o /dev/null -w '%{http_code}\n' --max-time 12 https://controlplane.tailscale.com/
```

A `302` from controlplane means egress to Tailscale works through the proxy.

### 2–4. Install, start daemon, authenticate — one script
Ask the user for the ephemeral tagged key, then:

```bash
TS_AUTHKEY='tskey-auth-xxxxxxxxxxxx' bash .claude/skills/tailscale-connect/scripts/ts-connect.sh claude-cloud
```

The script: installs Tailscale if missing → starts `tailscaled` (kernel mode if
`/dev/net/tun` + `CAP_NET_ADMIN`, else `--tun=userspace-networking`) → runs
`tailscale up --authkey=… --hostname=… --accept-routes --accept-dns=false` →
verifies. The HTTPS proxy is honored automatically; no proxy flags needed.

> DNS note: the script keeps the container's existing (proxy-based) DNS
> (`--accept-dns=false`) so it doesn't break other connectivity. Reach tailnet hosts
> by their **100.x tailnet IP** (see `tailscale status`) or, if the user turns on
> MagicDNS acceptance, by `<host>.<tailnet>.ts.net`.

### 5. Access Super_Diskie
The folder must be *served on the tailnet* by the Windows box (see Appendix). Consume
it by however the user set it up:

- **Tailscale Serve (recommended, HTTPS):** just fetch it.
  ```bash
  curl -sS https://<host>.<tailnet>.ts.net/Super_Diskie/   # kernel mode: direct
  ```
  (WebFetch works too once the name/IP resolves.)
- **Userspace-networking mode:** route through the local SOCKS5 the daemon opened:
  ```bash
  curl --socks5-hostname localhost:1055 http://<100.x.y.z>:<port>/Super_Diskie/
  ```
- **SMB share (kernel mode only):**
  ```bash
  apt-get install -y cifs-utils
  mkdir -p /mnt/superdiskie
  mount -t cifs //<100.x.y.z>/Super_Diskie /mnt/superdiskie -o username=<u>,password=<p>,ro
  ```

### 6. Teardown

```bash
tailscale logout        # drops the node; ephemeral nodes also auto-remove on exit
```

Then remind the user to **revoke the auth key** in the admin console.

## Appendix — one-time Windows-side serving (the user does this)
Putting the PC on the tailnet is not enough; the folder has to be *served*. Options:
- **Tailscale Serve** (simplest for Claude to read over HTTPS). Confirm exact flags with
  `tailscale serve --help` on the user's version, then serve the `Super_Diskie` directory
  at a path like `/Super_Diskie`.
- **SMB**: share the folder in Windows; reach it at `\\<magicdns-or-100.x>\Super_Diskie`.
- **WebDAV**: any small WebDAV server pointed at the folder.

## Installing this skill elsewhere
- **This repo's cloud sessions:** already loaded from `.claude/skills/`.
- **Local Claude Code (any project):** copy this folder to `~/.claude/skills/tailscale-connect/`.
- **Your taxonomy mirror:** copy into `01Skills/` for your records — but note the harness
  only auto-loads from `.claude/skills/`, so keep the live copy there.
