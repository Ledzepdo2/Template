#!/usr/bin/env bash
set -euo pipefail

USE_XCODEBUILD=true
DESTINATION="platform=iOS Simulator,name=iPhone 16,OS=18.0"
CI_MODE=false

for arg in "$@"; do
  case "$arg" in
    --spm)
      USE_XCODEBUILD=false
      ;;
    --ci)
      CI_MODE=true
      ;;
    --destination=*)
      DESTINATION="${arg#*=}"
      ;;
  esac
done

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/helpers/common.sh"

header "Running tests"
if [[ "$USE_XCODEBUILD" == true ]]; then
  ensure_command xcodebuild "Install Xcode 16 or newer."
  EXTRA_ARGS=()
  if [[ "$CI_MODE" == true ]]; then
    EXTRA_ARGS+=(-quiet)
  fi
  xcodebuild \
    -project "${ROOT_DIR}/${PROJECT_NAME}.xcodeproj" \
    -scheme "${PROJECT_NAME}" \
    -destination "${DESTINATION}" \
    "${EXTRA_ARGS[@]}" \
    clean test
else
  ensure_command swift "Install Swift 6 toolchain"
  pushd "$ROOT_DIR" >/dev/null
  swift test
  popd >/dev/null
fi
