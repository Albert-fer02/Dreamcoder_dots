#!/usr/bin/env bash
set -euo pipefail
ENV_FILE="${DREAMCODER_DOTS_ENV:-${0%/*}/dreamcoder-env.sh}"
# shellcheck source=/dev/null
[[ -f "${ENV_FILE}" ]] && source "${ENV_FILE}"
ok() { printf '✓ %s
' "$*"; }
warn() { printf '⚠ %s
' "$*"; }
check_path() { if [[ -e "${1}" ]]; then ok "present: ${1}"; else warn "missing: ${1}"; fi; }
control() { PYTHONPATH="${DREAMCODER_DOTS_DIR}/src${PYTHONPATH:+:${PYTHONPATH}}" python3 -m dreamcoder_theme.control "$@"; }
printf 'Dreamcoder Doctor
Structured health:
'; control doctor || true
printf '
Legacy checks:
Mode: '; head -1 "${CONFIG_HOME}/ghostty/themes/dreamcoder" 2>/dev/null || warn 'ghostty theme missing'
printf 'GTK: '
if command -v gsettings >/dev/null; then
    gsettings get org.gnome.desktop.interface color-scheme 2>/dev/null
else
    warn 'gsettings unavailable'
fi
printf 'Wallpaper: '; cat "${ML4W_CACHE_DIR}/current_wallpaper" 2>/dev/null || warn 'wallpaper cache missing'
printf 'opencode: '
if command -v python3 >/dev/null; then CONFIG_HOME="${CONFIG_HOME}" python3 -c 'import json,os,pathlib; p=pathlib.Path(os.environ["CONFIG_HOME"])/"opencode/tui.json"; print(json.loads(p.read_text()).get("theme","unset"))' 2>/dev/null || printf 'unknown
'; else printf 'unknown
'; fi
for path in "${CONFIG_HOME}/kitty" "${CONFIG_HOME}/ghostty" "${CONFIG_HOME}/starship.toml" \
    "${CONFIG_HOME}/hypr/colors.lua" "${CONFIG_HOME}/hypr/colors.conf" \
    "${CONFIG_HOME}/waybar/colors.css" "${CONFIG_HOME}/rofi/colors.rasi"; do check_path "${path}"; done
if [[ -L "${CONFIG_HOME}/dunst/dreamcoder-dunst.conf" ]]; then
    target=$(readlink "${CONFIG_HOME}/dunst/dreamcoder-dunst.conf")
    printf '  dunst symlink → %s\n' "${target}"
else
    warn 'dunst/dreamcoder-dunst.conf missing or not a symlink'
fi
if command -v systemctl >/dev/null && systemctl --user is-active --quiet dreamcoder-theme-auto.timer; then
    ok 'timer active'
else
    warn 'timer inactive'
fi
"${DREAMCODER_DOTS_DIR}/scripts/verify-theme-health.py"
