#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/helpers/common.sh"

if [[ ! -d "$ROOT_DIR/.git" ]]; then
  header "Skipping git hooks installation (no .git directory)"
  exit 0
fi

header "Installing git hooks"
HOOKS_DIR="$ROOT_DIR/.githooks"
GIT_HOOKS_DIR="$ROOT_DIR/.git/hooks"

mkdir -p "$GIT_HOOKS_DIR"
for hook in pre-commit pre-push prepare-commit-msg; do
  if [[ -f "$HOOKS_DIR/$hook" ]]; then
    substep "Linking $hook"
    ln -sf "../../.githooks/$hook" "$GIT_HOOKS_DIR/$hook"
    chmod +x "$HOOKS_DIR/$hook"
  fi
done
