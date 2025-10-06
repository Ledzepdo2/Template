#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/helpers/common.sh"

header "Bootstrapping ${PROJECT_NAME}"

"$SCRIPT_DIR/install_tools.sh"
"$SCRIPT_DIR/setup_modules.sh"
"$SCRIPT_DIR/install_git_hooks.sh"
"$SCRIPT_DIR/setup_ci.sh"

header "Bootstrap complete"
