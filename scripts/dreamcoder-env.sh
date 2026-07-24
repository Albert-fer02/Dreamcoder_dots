#!/usr/bin/env bash
# shellcheck disable=SC2034
set -euo pipefail

source "/lib/logging.sh"
source "/lib/env.sh"

ensure_dots_dir
CONFIG_HOME="${XDG_CONFIG_HOME:-${HOME}/.config}"
DATA_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}"
CACHE_HOME="${XDG_CACHE_HOME:-${HOME}/.cache}"
ML4W_CACHE_DIR="${ML4W_CACHE_DIR:-${CACHE_HOME}/ml4w/hyprland-dotfiles}"
