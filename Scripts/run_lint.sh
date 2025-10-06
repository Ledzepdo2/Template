#!/usr/bin/env bash
set -euo pipefail

STRICT=false
if [[ "${1:-}" == "--strict" ]]; then
  STRICT=true
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/helpers/common.sh"

ensure_command swiftlint "Install SwiftLint via Scripts/install_tools.sh"

header "Running SwiftLint"
if [[ "$STRICT" == true ]]; then
  swiftlint --strict
else
  swiftlint
fi
