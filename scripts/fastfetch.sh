#!/usr/bin/env bash
set -euo pipefail

command -v fastfetch >/dev/null || exit 0
IMG_DIR="${XDG_CONFIG_HOME:-${HOME}/.config}/dreamcoder"
IMG="${IMG_DIR}/Dreamcoder01.jpg"

if [[ -f "${IMG}" ]]; then
    fastfetch --kitty "${IMG}"
else
    fastfetch
fi
