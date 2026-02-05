#!/usr/bin/env bash
#
# pre-compact.sh - PreCompact hook to remind about saving discoveries

set -euo pipefail

cat <<'EOF'
{
  "hookSpecificOutput": {
    "hookEventName": "PreCompact",
    "additionalContext": "CONTEXT COMPACTION IMMINENT: Before this conversation is compacted, save any unsaved discoveries to memento. Review for: debugging insights, project patterns, user preferences, tool discoveries, domain knowledge. Use mcp__memento__create_entities to store new knowledge."
  }
}
EOF
exit 0
