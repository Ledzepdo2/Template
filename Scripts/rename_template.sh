#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "usage: $0 NewProjectName"
  exit 1
fi

NEW_NAME="$1"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/helpers/common.sh"

header "Renaming template from ${PROJECT_NAME_PLACEHOLDER} to ${NEW_NAME}"

replace_placeholder "$ROOT_DIR" "$NEW_NAME"

mv "$ROOT_DIR/{{ProjectName}}.xcodeproj" "$ROOT_DIR/${NEW_NAME}.xcodeproj"

header "Rename complete. Open ${NEW_NAME}.xcodeproj"
