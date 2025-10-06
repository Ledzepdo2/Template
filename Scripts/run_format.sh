#!/usr/bin/env bash
set -euo pipefail

MODE="format"
if [[ "${1:-}" == "--lint" ]]; then
  MODE="lint"
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/helpers/common.sh"

ensure_command swiftformat "Install SwiftFormat via Scripts/install_tools.sh"

header "Running SwiftFormat (${MODE})"
if [[ "$MODE" == "lint" ]]; then
  swiftformat --lint "$ROOT_DIR"
else
  swiftformat "$ROOT_DIR"
fi
