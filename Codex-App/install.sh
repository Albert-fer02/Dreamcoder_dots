#!/usr/bin/env bash
set -euo pipefail

MODULE_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_HOME="${XDG_CONFIG_HOME:-${HOME}/.config}"
THEME_DIR="${CODEX_APP_THEME_DIR:-${CONFIG_HOME}/codex-app/themes}"

mkdir -p "${THEME_DIR}"

ln -sfn "${MODULE_DIR}/theme/dreamcoder.json" "${THEME_DIR}/dreamcoder.json"
ln -sfn "${MODULE_DIR}/theme/dreamcoder.toml" "${THEME_DIR}/dreamcoder.toml"

printf 'Dreamcoder Codex App theme linked at: %s\n' "${THEME_DIR}"
