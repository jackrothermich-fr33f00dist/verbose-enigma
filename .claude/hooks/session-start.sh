#!/bin/bash
# Ember session bootstrap — injected into Claude's context at every session start.
set -euo pipefail

REPO="${CLAUDE_PROJECT_DIR:-$(git -C "$(dirname "$0")" rev-parse --show-toplevel 2>/dev/null)}"

echo "=== verbose-enigma session start ==="
echo ""

# Inject Ember's persistent memory
cat "$REPO/Ember_Playbook.md"
echo ""
echo "---"
echo ""

# Quick workspace status
LAST_ACTIVITY=$(grep -m1 '^## [0-9]\{4\}-[0-9]\{2\}-[0-9]\{2\}' "$REPO/logs/activity.md" 2>/dev/null | sed 's/^## //' || echo "unknown")
ROADMAP_DATE=$(grep -m1 'Last updated:' "$REPO/plans/roadmap.md" 2>/dev/null | sed 's/.*Last updated: //' || echo "unknown")
BRANCH=$(git -C "$REPO" rev-parse --abbrev-ref HEAD 2>/dev/null || echo "unknown")
DIRTY=$(git -C "$REPO" status --porcelain 2>/dev/null | wc -l)

echo "Workspace snapshot:"
echo "  Branch       : $BRANCH"
echo "  Last activity: $LAST_ACTIVITY"
echo "  Roadmap date : $ROADMAP_DATE"
if [ "$DIRTY" -gt 0 ]; then
  echo "  Uncommitted  : $DIRTY file(s) — commit before ending session"
else
  echo "  Working tree : clean"
fi

# Flag unresolved OpenClaw blockers
if grep -q "Unresolved" "$REPO/logs/openclaw_errors.md" 2>/dev/null; then
  echo ""
  echo "  OpenClaw: unresolved items in logs/openclaw_errors.md"
fi

echo ""

# EOS-2: surface roadmap HIGH PRIORITY / Open Branch Blockers items before anything else
BLOCKERS=$(awk '/^### Open Branch Blockers/{found=1; next} /^---/{if(found) exit} found && NF{print}' "$REPO/plans/roadmap.md" 2>/dev/null)
HIGH_PRIORITY=$(grep -n "HIGH PRIORITY" "$REPO/plans/roadmap.md" 2>/dev/null)
if [ -n "$BLOCKERS" ] || [ -n "$HIGH_PRIORITY" ]; then
  echo "*** ROADMAP ALERTS (check before picking a task) ***"
  if [ -n "$HIGH_PRIORITY" ]; then
    echo "$HIGH_PRIORITY"
  fi
  if [ -n "$BLOCKERS" ]; then
    echo "Open Branch Blockers:"
    echo "$BLOCKERS"
  fi
  echo ""
fi

# Inject Dreams hot section if it exists
if [ -f "$REPO/Ember_Dreams.md" ]; then
  echo "--- Ember_Dreams.md (active) ---"
  echo ""
  awk '/^<!-- ACTIVE/{found=1; next} /^<!-- ARCHIVE/{exit} found{print}' "$REPO/Ember_Dreams.md"
  echo ""
fi

echo "Read plans/roadmap.md for current priorities before acting."
