#!/usr/bin/env bash
# Workspace health check for verbose-enigma.
# Run from anywhere inside the repo. Exits 0 if healthy, 1 if any check fails.

set -euo pipefail

REPO="$(git -C "$(dirname "$0")" rev-parse --show-toplevel 2>/dev/null || echo /home/user/verbose-enigma)"
ERRORS=0
WARNINGS=0

green() { printf '\033[0;32m✓\033[0m %s\n' "$*"; }
red()   { printf '\033[0;31m✗\033[0m %s\n' "$*"; ERRORS=$((ERRORS+1)); }
warn()  { printf '\033[0;33m!\033[0m %s\n' "$*"; WARNINGS=$((WARNINGS+1)); }

echo "=== verbose-enigma workspace check ==="
echo "Repo: $REPO"
echo ""

# --- Core files ---
echo "[ Core files ]"
for f in \
  Ember_Playbook.md \
  README.md \
  plans/roadmap.md \
  logs/activity.md \
  logs/openclaw_errors.md \
  openclaw/AGENTS.md \
  openclaw/openclaw.json \
  openclaw/.env.template \
  openclaw/SETUP.md; do
  if [ -f "$REPO/$f" ] && [ -s "$REPO/$f" ]; then
    bytes=$(wc -c < "$REPO/$f")
    green "$f  (${bytes}B)"
  else
    red "MISSING or empty: $f"
  fi
done

echo ""
echo "[ Charybdis contracts ]"
for f in \
  charybdis/README.md \
  charybdis/whisperbot_handoff_contract.md \
  charybdis/processed_vault_manifest_schema.md \
  charybdis/sigilforge_bundle_input_contract.md \
  charybdis/orcavault_drop_receipt_contract.md; do
  if [ -f "$REPO/$f" ] && [ -s "$REPO/$f" ]; then
    green "$f"
  else
    red "MISSING: $f"
  fi
done

echo ""
echo "[ Config validity ]"
# openclaw.json is JSON5 in practice but validate as JSON (template uses valid JSON)
if node -e "JSON.parse(require('fs').readFileSync('$REPO/openclaw/openclaw.json','utf8').replace(/\/\/.*/g,'').replace(/,(\s*[}\]])/g,'\$1'))" 2>/dev/null; then
  green "openclaw/openclaw.json — parseable"
else
  warn "openclaw/openclaw.json — not strict-JSON-clean (OK if it uses JSON5 comments/trailing commas)"
fi

echo ""
echo "[ Activity log recency ]"
LAST_DATE=$(grep -oE '^## [0-9]{4}-[0-9]{2}-[0-9]{2}' "$REPO/logs/activity.md" | head -1 | grep -oE '[0-9]{4}-[0-9]{2}-[0-9]{2}' || true)
if [ -n "$LAST_DATE" ]; then
  TODAY=$(date +%Y-%m-%d)
  DAYS_AGO=$(( ( $(date -d "$TODAY" +%s) - $(date -d "$LAST_DATE" +%s) ) / 86400 ))
  if [ "$DAYS_AGO" -le 7 ]; then
    green "Last activity entry: $LAST_DATE  (${DAYS_AGO}d ago)"
  else
    warn "Last activity entry: $LAST_DATE  (${DAYS_AGO}d ago — may be stale)"
  fi
else
  warn "Could not parse last activity date"
fi

echo ""
echo "[ Git status ]"
cd "$REPO"
BRANCH=$(git rev-parse --abbrev-ref HEAD)
DIRTY=$(git status --porcelain | wc -l)
green "Branch: $BRANCH"
if [ "$DIRTY" -eq 0 ]; then
  green "Working tree clean"
else
  warn "$DIRTY uncommitted change(s) — commit before ending session"
fi

BEHIND=$(git rev-list HEAD..origin/"$BRANCH" --count 2>/dev/null || echo "?")
if [ "$BEHIND" = "0" ] || [ "$BEHIND" = "?" ]; then
  green "Up to date with origin"
else
  warn "Behind origin by $BEHIND commit(s) — consider pulling"
fi

echo ""
echo "[ OpenClaw blockers ]"
if grep -q "Unresolved" "$REPO/logs/openclaw_errors.md" 2>/dev/null; then
  warn "logs/openclaw_errors.md has unresolved items — check recovery checklist"
else
  green "No unresolved OpenClaw errors flagged"
fi

echo ""
echo "============================================"
if [ "$ERRORS" -gt 0 ]; then
  echo "RESULT: FAIL  ($ERRORS error(s), $WARNINGS warning(s))"
  exit 1
else
  echo "RESULT: PASS  (0 errors, $WARNINGS warning(s))"
  exit 0
fi
