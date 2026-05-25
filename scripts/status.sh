#!/usr/bin/env bash
set -euo pipefail
ENV_FILE="${DREAMCODER_DOTS_ENV:-${0%/*}/dreamcoder-env.sh}"
# shellcheck source=/dev/null
[[ -f "${ENV_FILE}" ]] && source "${ENV_FILE}"
LIGHT_START="${DREAMCODER_LIGHT_START:-7}"; DUSK_START="${DREAMCODER_DUSK_START:-16}"; DARK_START="${DREAMCODER_DARK_START:-18}"; HOUR="$(date +%H)"
EXPECTED="dark"
if (( 10#${HOUR} >= LIGHT_START && 10#${HOUR} < DUSK_START )); then EXPECTED="light"; fi
if (( 10#${HOUR} >= DUSK_START && 10#${HOUR} < DARK_START )); then EXPECTED="dusk"; fi
json_bg() { python3 -c 'import json,sys,pathlib; d=json.loads(pathlib.Path(sys.argv[1]).read_text()); print(d.get("defs", {}).get("dreamBackground") or d.get("theme", {}).get("background") or "missing")' "$1" 2>/dev/null || printf 'missing'; }
gtk_mode() { v=$(grep -m1 '^gtk-application-prefer-dark-theme=' "${CONFIG_HOME}/gtk-3.0/settings.ini" 2>/dev/null | cut -d= -f2); if [[ "${v}" == "1" ]]; then printf dark; elif [[ "${v}" == "0" ]]; then printf light; else printf unknown; fi; }
starship_bg() { grep -m1 '^bg = ' "${CONFIG_HOME}/starship.toml" 2>/dev/null | sed 's/.*= "//;s/".*//'; }
file_mode() { if grep -qi 'Dreamcoder Light' "$1" 2>/dev/null; then printf light; elif grep -qi 'Dreamcoder Dusk' "$1" 2>/dev/null; then printf dusk; elif grep -qi 'Dreamcoder Dark' "$1" 2>/dev/null; then printf dark; else printf unknown; fi; }
bg_mode() { case "$1" in '#15100d'|'#13100d'|'#101216') printf dark;; '#ebe4d6') printf dusk;; '#f3eadc'|'#f8f2ea'|'#f6f1e8'|'#f7f5f0') printf light;; *) printf unknown;; esac; }
check() { local name="$1" actual="$2"; if [[ "${actual}" == "${EXPECTED}" ]]; then printf '✓ %s=%s\n' "${name}" "${actual}"; else printf '✗ %s=%s expected=%s\n' "${name}" "${actual}" "${EXPECTED}"; return 1; fi; }
printf 'Dreamcoder Status\n'
printf 'time=%s expected=%s window=light:%s-%s dusk:%s-%s\n' "$(date '+%H:%M %Z')" "${EXPECTED}" "${LIGHT_START}" "${DUSK_START}" "${DUSK_START}" "${DARK_START}"
status=0
check ghostty "$(file_mode "${CONFIG_HOME}/ghostty/themes/dreamcoder")" || status=1
check kitty "$(file_mode "${CONFIG_HOME}/kitty/colors-dreamcoder.conf")" || status=1
check opencode "$(bg_mode "$(json_bg "${CONFIG_HOME}/opencode/themes/dreamcoder.json")")" || status=1
check repo_opencode "$(bg_mode "$(json_bg "${DREAMCODER_DOTS_DIR}/.opencode/themes/dreamcoder.json")")" || status=1
check starship "$(bg_mode "$(starship_bg)")" || status=1
check gtk "$(gtk_mode)" || status=1
exit "${status}"
