#!/usr/bin/env bash
set -euo pipefail

command -v fastfetch >/dev/null || exit 0
CONFIG="${XDG_CONFIG_HOME:-${HOME}/.config}/fastfetch/config.jsonc"
IMG_DIR="${XDG_CONFIG_HOME:-${HOME}/.config}/dreamcoder"
IMG="${IMG_DIR}/Dreamcoder01.jpg"

if [[ -f "${IMG}" ]]; then
    fastfetch --config "${CONFIG}" --logo "${IMG}" --logo-type kitty --logo-recache true
else
    fastfetch
fi
