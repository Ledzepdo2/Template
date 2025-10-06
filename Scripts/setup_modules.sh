#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/helpers/common.sh"

header "Resolving Swift Package dependencies"
ensure_command swift "Install the latest Command Line Tools (Swift 6)"

pushd "$ROOT_DIR" >/dev/null
swift package resolve
popd >/dev/null

header "Ensuring derived data folders"
mkdir -p "$ROOT_DIR/.derived-data"
