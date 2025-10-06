#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/helpers/common.sh"

header "Installing Homebrew tools"
ensure_command brew "Install Homebrew from https://brew.sh before running bootstrap."

TOOLS=(swiftlint swiftformat)

for tool in "${TOOLS[@]}"; do
  if brew list --versions "$tool" >/dev/null 2>&1; then
    substep "$tool already installed"
  else
    substep "Installing $tool"
    brew install "$tool"
  fi
  substep "Ensuring latest $tool"
  brew upgrade "$tool" || true
  brew link "$tool" --overwrite >/dev/null 2>&1 || true
  substep "Using $(command -v $tool)"
  "$tool" --version || true
  echo
  if [[ "$tool" == "swiftformat" ]]; then
    substep "SwiftFormat configuration defaulted to .swiftformat"
    [[ -f "$ROOT_DIR/.swiftformat" ]] || cat <<'FMT' > "$ROOT_DIR/.swiftformat"
--swiftversion 6.0
--recursive
--exclude Modules/**/Generated
FMT
  fi
  if [[ "$tool" == "swiftlint" ]]; then
    [[ -f "$ROOT_DIR/.swiftlint.yml" ]] || cat <<'LINT' > "$ROOT_DIR/.swiftlint.yml"
disabled_rules:
  - line_length
  - todo
opt_in_rules:
  - explicit_init
  - force_unwrapping
included:
  - App
  - Modules
  - Tests
reporter: "xcode"
LINT
  fi
done
