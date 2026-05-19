#!/usr/bin/env bash
set -euo pipefail

ENV_FILE="${DREAMCODER_DOTS_ENV:-${0%/*}/dreamcoder-env.sh}"
# shellcheck source=/dev/null
[[ -f "${ENV_FILE}" ]] && source "${ENV_FILE}"

ok() { printf '✓ %s\n' "$*"; }
warn() { printf '⚠ %s\n' "$*"; }
check_path() { if [[ -e "${1}" ]]; then ok "present: ${1}"; else warn "missing: ${1}"; fi; }

printf 'Dreamcoder Doctor\n'
printf 'Mode: '; head -1 "${CONFIG_HOME}/ghostty/themes/dreamcoder" 2>/dev/null || warn 'ghostty theme missing'
printf 'GTK: '; if command -v gsettings >/dev/null; then gsettings get org.gnome.desktop.interface color-scheme; else warn 'gsettings unavailable'; fi
printf 'Wallpaper: '; cat "${ML4W_CACHE_DIR}/current_wallpaper" 2>/dev/null || warn 'wallpaper cache missing'
printf 'opencode: '
if command -v python3 >/dev/null; then
    CONFIG_HOME="${CONFIG_HOME}" python3 -c 'import json,os,pathlib; p=pathlib.Path(os.environ["CONFIG_HOME"])/"opencode/tui.json"; print(json.loads(p.read_text()).get("theme","unset"))' 2>/dev/null || printf 'unknown\n'
else
    printf 'unknown\n'
fi
check_path "${CONFIG_HOME}/kitty"
check_path "${CONFIG_HOME}/ghostty"
check_path "${CONFIG_HOME}/starship.toml"
if command -v systemctl >/dev/null && systemctl --user is-active --quiet dreamcoder-theme-auto.timer; then ok 'timer active'; else warn 'timer inactive'; fi
"${DREAMCODER_DOTS_DIR}/scripts/verify-theme-health.py"
