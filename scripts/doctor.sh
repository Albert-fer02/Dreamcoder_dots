#!/usr/bin/env bash
set -euo pipefail
ENV_FILE="${DREAMCODER_DOTS_ENV:-${0%/*}/dreamcoder-env.sh}"
# shellcheck source=/dev/null
[[ -f "${ENV_FILE}" ]] && source "${ENV_FILE}"
ok() { printf '✓ %s
' "$*"; }
warn() { printf '⚠ %s
' "$*"; }
check_path() { [[ -e "${1}" ]] && ok "present: ${1}" || warn "missing: ${1}"; }
control() { PYTHONPATH="${DREAMCODER_DOTS_DIR}/scripts${PYTHONPATH:+:${PYTHONPATH}}" python3 -m dreamcoder_theme.control "$@"; }
printf 'Dreamcoder Doctor
Structured health:
'; control doctor || true
printf '
Legacy checks:
Mode: '; head -1 "${CONFIG_HOME}/ghostty/themes/dreamcoder" 2>/dev/null || warn 'ghostty theme missing'
printf 'GTK: '; command -v gsettings >/dev/null && gsettings get org.gnome.desktop.interface color-scheme 2>/dev/null || warn 'gsettings unavailable'
printf 'Wallpaper: '; cat "${ML4W_CACHE_DIR}/current_wallpaper" 2>/dev/null || warn 'wallpaper cache missing'
printf 'opencode: '
if command -v python3 >/dev/null; then CONFIG_HOME="${CONFIG_HOME}" python3 -c 'import json,os,pathlib; p=pathlib.Path(os.environ["CONFIG_HOME"])/"opencode/tui.json"; print(json.loads(p.read_text()).get("theme","unset"))' 2>/dev/null || printf 'unknown
'; else printf 'unknown
'; fi
for path in "${CONFIG_HOME}/kitty" "${CONFIG_HOME}/ghostty" "${CONFIG_HOME}/starship.toml"; do check_path "${path}"; done
command -v systemctl >/dev/null && systemctl --user is-active --quiet dreamcoder-theme-auto.timer && ok 'timer active' || warn 'timer inactive'
"${DREAMCODER_DOTS_DIR}/scripts/verify-theme-health.py"
