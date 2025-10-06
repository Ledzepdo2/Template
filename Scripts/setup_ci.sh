#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/helpers/common.sh"

header "Ensuring CI configuration"
CI_FILE="$ROOT_DIR/.github/workflows/ci.yml"

if [[ -f "$CI_FILE" ]]; then
  substep "CI workflow already present"
  exit 0
fi

cat <<'YAML' > "$CI_FILE"
name: CI

on:
  pull_request:
  push:
    branches:
      - main
      - develop

jobs:
  build-and-test:
    runs-on: macos-15
    steps:
      - uses: actions/checkout@v4
      - name: Configure Xcode version
        uses: maxim-lobanov/setup-xcode@v1
        with:
          xcode-version: "16.0"
      - name: Bootstrap project
        run: |
          ./Scripts/bootstrap.sh
      - name: Run format check
        run: |
          ./Scripts/run_format.sh --lint
      - name: Run lint
        run: |
          ./Scripts/run_lint.sh --strict
      - name: Run tests
        run: |
          ./Scripts/run_tests.sh --ci
YAML
