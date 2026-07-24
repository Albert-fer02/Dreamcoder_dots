#!/usr/bin/env bash
# ── Dreamcoder Dots — Environment Resolution ─────────────────────────
# Source after lib/logging.sh
set -euo pipefail

ensure_dots_dir() {
    if [[ -z "${DREAMCODER_DOTS_DIR:-}" ]]; then
        export DREAMCODER_DOTS_DIR
        DREAMCODER_DOTS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
    fi
}

is_gui_session() {
    [[ -n "${WAYLAND_DISPLAY:-}" || -n "${DISPLAY:-}" ]]
}
