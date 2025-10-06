#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")"/../.. && pwd)"
PROJECT_NAME_PLACEHOLDER="{{ProjectName}}"
PROJECT_NAME="${PROJECT_NAME:-$PROJECT_NAME_PLACEHOLDER}"

function header() {
  printf "\n\033[1;34m==> %s\033[0m\n" "$1"
}

function substep() {
  printf "\033[0;36m  -> %s\033[0m\n" "$1"
}

function ensure_command() {
  local cmd="$1"
  local install_hint="$2"
  if ! command -v "$cmd" >/dev/null 2>&1; then
    printf "\033[0;31mMissing required command: %s\n%s\033[0m\n" "$cmd" "$install_hint"
    exit 1
  fi
}

function replace_placeholder() {
  local path="$1"
  local name="$2"
  local sed_in_place=(-i)
  if [[ "${OSTYPE:-}" == "darwin"* ]]; then
    sed_in_place=(-i '')
  fi

  LC_ALL=C find "$path" \
    \( -path "$path/.git" -o -path "$path/.build" \) -prune -o \
    -type f \
    \( -name '*.swift' -o -name '*.plist' -o -name '*.pbxproj' -o -name '*.md' -o -name '*.yml' -o -name '*.xcconfig' -o -name '*.sh' -o -name 'Package.swift' \) \
    -exec sed "${sed_in_place[@]}" "s/{{ProjectName}}/${name}/g" {} +
}
