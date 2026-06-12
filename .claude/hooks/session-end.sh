#!/bin/bash
# ForgeFyre Falls Silent — Ember session-end hook
# Writes Dreams snapshot and prompts the close routine.
set -euo pipefail

REPO="${CLAUDE_PROJECT_DIR:-$(git -C "$(dirname "$0")" rev-parse --show-toplevel 2>/dev/null)}"
DREAMS="$REPO/Ember_Dreams.md"
NOW=$(date '+%Y-%m-%d %H:%M')
BRANCH=$(git -C "$REPO" rev-parse --abbrev-ref HEAD 2>/dev/null || echo "unknown")
DIRTY=$(git -C "$REPO" status --porcelain 2>/dev/null | wc -l | tr -d ' ')
LAST_COMMITS=$(git -C "$REPO" log --oneline -3 2>/dev/null | sed 's/^/  - /' || echo "  - none")
OPENCLAW_STATUS="clean"
if grep -q "Unresolved" "$REPO/logs/openclaw_errors.md" 2>/dev/null; then
  OPENCLAW_STATUS="unresolved items in logs/openclaw_errors.md"
fi

# Preserve the archive section before overwriting
ARCHIVE=$(awk '/^<!-- ARCHIVE/{found=1} found{print}' "$DREAMS" 2>/dev/null \
  || printf '<!-- ARCHIVE — append-only. One entry appended per session by session-end hook. -->\n## Archive\n\n_Session archive begins after first sleep._\n')

# Build updated Dreams file (snapshot model — active section fully replaced)
cat > "$DREAMS" <<DREAMS_EOF
# Ember_Dreams.md — Between-Session Memory

Snapshot model: ACTIVE section is overwritten each sleep. Archive is append-only.
**Wake reads ACTIVE only.** Do not read Archive unless investigating history.
Hot Recommendations replace each session — do not stack.
Durable knowledge that survives multiple sessions graduates to \`Ember_Playbook.md\`.

---

<!-- ACTIVE — overwritten each sleep by session-end hook -->
## Last Sleep

- **Date**: $NOW
- **Branch**: $BRANCH
- **Last commits**:
$LAST_COMMITS
- **Uncommitted at close**: ${DIRTY} file(s)
- **OpenClaw**: $OPENCLAW_STATUS

## Hot Recommendations

_[Ember: replace this with your actual handoff notes before closing]_

## Current Blockers

$(grep -i "Unresolved\|blocked\|Status: Unresolved" "$REPO/logs/openclaw_errors.md" 2>/dev/null \
  | head -5 | sed 's/^/- /' \
  || echo "- None flagged in openclaw_errors.md")

---

$ARCHIVE
DREAMS_EOF

echo ""
echo "=== ForgeFyre Falls Silent ==="
echo ""
echo "Dreams snapshot written for $NOW."
echo ""
echo "Complete the close routine before ending this session:"
echo "  1. Replace 'Hot Recommendations' in Ember_Dreams.md with your actual handoff notes"
echo "  2. Log this session in logs/activity.md"
echo "  3. Update plans/roadmap.md if priorities changed"
echo "  4. Update Ember_Playbook.md if anything fundamental changed"
echo "  5. Commit and push — leave working tree clean"
echo ""
if [ "$DIRTY" -gt 0 ]; then
  echo "  WARNING: $DIRTY uncommitted file(s) — commit before closing."
  echo ""
fi
