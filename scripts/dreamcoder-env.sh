#!/usr/bin/env bash
# shellcheck disable=SC2034
set -euo pipefail

DREAMCODER_ENV_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${DREAMCODER_ENV_DIR}/../lib/logging.sh"
source "${DREAMCODER_ENV_DIR}/../lib/env.sh"

ensure_dots_dir
CONFIG_HOME="${XDG_CONFIG_HOME:-${HOME}/.config}"
DATA_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}"
CACHE_HOME="${XDG_CACHE_HOME:-${HOME}/.cache}"
ML4W_CACHE_DIR="${ML4W_CACHE_DIR:-${CACHE_HOME}/ml4w/hyprland-dotfiles}"
