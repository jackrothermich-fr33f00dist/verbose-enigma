#!/usr/bin/env bash
# ts-connect.sh — connect this environment to a Tailscale tailnet, then verify.
#
# Usage:   TS_AUTHKEY='tskey-auth-...' ./ts-connect.sh [hostname]
#
# The auth key MUST be an ephemeral, tagged key the user generated and will revoke.
# It is read from the environment, used in-memory, and unset immediately — this
# script never writes it to disk, a log, or a commit.
set -euo pipefail

HOSTNAME_ARG="${1:-claude-$(hostname 2>/dev/null || echo ephemeral)}"
SOCK=/var/run/tailscale/tailscaled.sock
log(){ printf '\033[36m[ts-connect]\033[0m %s\n' "$*"; }

# 0. Already connected? (the common case on a local machine already on the tailnet)
if command -v tailscale >/dev/null 2>&1 && tailscale status >/dev/null 2>&1; then
  log "Already connected to a tailnet:"; tailscale status | head -3
  exit 0
fi

# 1. Preflight
if [ "$(id -u)" != 0 ]; then
  log "Need root to install and start tailscaled. Re-run as root."; exit 1
fi
log "Control-plane reachability:"
curl -sS -o /dev/null -w '  controlplane.tailscale.com -> HTTP %{http_code}\n' \
  --max-time 12 https://controlplane.tailscale.com/ || log "  (control plane unreachable — check egress)"

# 2. Install if missing (official script honors HTTPS_PROXY)
if ! command -v tailscaled >/dev/null 2>&1; then
  log "Installing Tailscale..."
  curl -fsSL https://tailscale.com/install.sh | sh
fi
log "$(tailscale version | head -1)"

# 3. Start the daemon: kernel mode if we have a tun device + NET_ADMIN, else userspace.
mkdir -p /var/lib/tailscale /var/run/tailscale
if ! pgrep -x tailscaled >/dev/null 2>&1; then
  if [ -c /dev/net/tun ]; then
    log "Starting tailscaled (kernel mode)..."
    nohup tailscaled --state=/var/lib/tailscale/tailscaled.state --socket="$SOCK" \
      >/tmp/tailscaled.log 2>&1 &
  else
    log "No /dev/net/tun — starting tailscaled (userspace networking, SOCKS5 :1055)..."
    nohup tailscaled --tun=userspace-networking \
      --socks5-server=localhost:1055 --outbound-http-proxy-listen=localhost:1055 \
      --state=/var/lib/tailscale/tailscaled.state --socket="$SOCK" \
      >/tmp/tailscaled.log 2>&1 &
  fi
  sleep 4
fi
pgrep -x tailscaled >/dev/null 2>&1 || { log "tailscaled failed to start:"; tail -20 /tmp/tailscaled.log; exit 1; }

# 4. Authenticate — requires the user-provided ephemeral key.
: "${TS_AUTHKEY:?Set TS_AUTHKEY to an ephemeral, tagged Tailscale auth key you generated}"
log "Joining tailnet as '$HOSTNAME_ARG' (HTTPS proxy auto-honored via DERP)..."
tailscale up --authkey="$TS_AUTHKEY" --hostname="$HOSTNAME_ARG" \
  --accept-routes --accept-dns=false
unset TS_AUTHKEY   # scrub the secret from this process's environment

# 5. Verify
log "Connected. Status:"
tailscale status | head -8
log "This node's tailnet IP: $(tailscale ip -4 2>/dev/null | head -1)"
log "Done. Reach Super_Diskie via its 100.x IP (above) or *.ts.net if MagicDNS is accepted."
log "Remember to revoke this auth key in the Tailscale admin console when finished."
