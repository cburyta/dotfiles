#!/bin/sh
set -eu

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
SYNC="$SCRIPT_DIR/../bin/agent-sync"
ROOT=$(mktemp -d "${TMPDIR:-/tmp}/agent-sync-test.XXXXXX")
trap 'rm -rf "$ROOT"' EXIT HUP INT TERM

HOME="$ROOT/home"
CURRENT="$ROOT/current-agents"
LEGACY="$ROOT/legacy-agents"
STATE="$ROOT/state/manifest"
export HOME CURRENT LEGACY STATE
export AGENT_SYNC_STATE_FILE="$STATE"
mkdir -p "$HOME" "$CURRENT/skills/kept" "$CURRENT/skills/old" "$CURRENT/commands" \
  "$LEGACY/skills/legacy" "$HOME/.claude/skills" "$HOME/.pi/agent/skills" \
  "$HOME/.cursor/skills" "$HOME/.cursor/commands" "$HOME/.config/opencode/skills" \
  "$HOME/.config/opencode/command"
printf 'kept\n' > "$CURRENT/skills/kept/SKILL.md"
printf 'old\n' > "$CURRENT/skills/old/SKILL.md"
printf 'command\n' > "$CURRENT/commands/old.md"
printf 'legacy\n' > "$LEGACY/skills/legacy/SKILL.md"

export AGENT_PATH="$CURRENT:$LEGACY"
"$SYNC" >/dev/null
[ -L "$HOME/.claude/skills/kept" ]
[ -L "$HOME/.claude/skills/legacy" ]
[ -f "$STATE" ]

# Local content must survive pruning.
mkdir -p "$HOME/.claude/skills/local-only"
printf 'local\n' > "$HOME/.claude/skills/local-only/SKILL.md"

# A deleted source is removed using the persisted ownership manifest.
rm -rf "$CURRENT/skills/old" "$CURRENT/commands/old.md"
"$SYNC" --prune >/dev/null
[ ! -e "$HOME/.claude/skills/old" ]
[ ! -e "$HOME/.cursor/commands/old.md" ]
[ -e "$HOME/.claude/skills/kept" ]
[ -e "$HOME/.claude/skills/local-only/SKILL.md" ]

# A removed source root is handled by the one-time legacy-root migration.
export AGENT_PATH="$CURRENT"
"$SYNC" --dry-run --prune --legacy-root "$LEGACY" > "$ROOT/dry-run"
grep 'remove .*managed' "$ROOT/dry-run" >/dev/null
[ -L "$HOME/.claude/skills/legacy" ]
"$SYNC" --prune --legacy-root "$LEGACY" >/dev/null
[ ! -e "$HOME/.claude/skills/legacy" ]

# Unrelated symlinks must survive.
printf 'outside\n' > "$ROOT/outside"
ln -s "$ROOT/outside" "$HOME/.claude/skills/unmanaged"
"$SYNC" --prune >/dev/null
[ -L "$HOME/.claude/skills/unmanaged" ]

# Relative managed links are recognized by the migration path.
mkdir -p "$ROOT/relative/skills"
printf 'relative\n' > "$ROOT/relative/skills/SKILL.md"
ln -s "../../../../relative/skills" "$HOME/.claude/skills/relative"
"$SYNC" --prune --legacy-root "$ROOT/relative" >/dev/null
[ ! -e "$HOME/.claude/skills/relative" ]

echo "agent-sync tests: ok"
