#!/usr/bin/env bash
# shellcheck disable=SC2034
set -euo pipefail

DREAMCODER_DOTS_DIR="${DREAMCODER_DOTS_DIR:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"
CONFIG_HOME="${XDG_CONFIG_HOME:-${HOME}/.config}"
DATA_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}"
CACHE_HOME="${XDG_CACHE_HOME:-${HOME}/.cache}"
ML4W_CACHE_DIR="${ML4W_CACHE_DIR:-${CACHE_HOME}/ml4w/hyprland-dotfiles}"
