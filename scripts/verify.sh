#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ENV_FILE="${DREAMCODER_DOTS_ENV:-${SCRIPT_DIR}/dreamcoder-env.sh}"
# shellcheck source=/dev/null
[[ -f "${ENV_FILE}" ]] && source "${ENV_FILE}"
ok() { printf '✓ %s
' "${*}"; }
fail() { printf '✗ %s
' "${*}" >&2; return 1; }
check_path() { [[ -e "${1}" ]] || { fail "${1} is missing"; return; }; ok "${1}"; }
control() { PYTHONPATH="${DREAMCODER_DOTS_DIR}/scripts${PYTHONPATH:+:${PYTHONPATH}}" python3 -m dreamcoder_theme.control "${@}"; }
command -v starship >/dev/null || fail 'Missing dependency: starship'
for path in "${CONFIG_HOME}/kitty" "${CONFIG_HOME}/ghostty" "${CONFIG_HOME}/fastfetch" "${CONFIG_HOME}/starship.toml" "${CONFIG_HOME}/kitty/dreamcoder-ui.conf" "${DATA_HOME}/warp-terminal/themes"; do check_path "${path}"; done
PI_AGENT_DIR="${PI_AGENT_DIR:-${HOME}/.pi/agent}"; check_path "${PI_AGENT_DIR}/themes/dreamcoder.json"
"${DREAMCODER_DOTS_DIR}/scripts/verify-pi-theme.py" "${PI_AGENT_DIR}/themes/dreamcoder.json" "${PI_AGENT_DIR}/settings.json"
for file in starship.toml starship-light.toml; do STARSHIP_CONFIG="${DREAMCODER_DOTS_DIR}/Shell/.config/${file}" starship explain >/dev/null; done
"${DREAMCODER_DOTS_DIR}/scripts/verify-theme-health.py" >/dev/null
python3 -m unittest tests/test_dreamcoder_control_center.py tests/test_dreamcoder_tui.py tests/test_dreamcoder_docs_report.py tests/test_dreamcoder_audit.py tests/test_dreamcoder_repair_catalog.py >/dev/null
CONTROL_CASES=('doctor --json' 'dashboard --json' 'dashboard --markdown' 'tui render --json' 'tui render' 'tui set terminal.default_mode light --dry-run --json' 'docs report --json' 'docs report --markdown' 'audit compare --json' 'audit compare --markdown' 'settings schema --json' 'settings validate --json' 'repair catalog --json' 'repair plan --json' 'repair apply --dry-run --json' 'profile apply asus-vivobook15 --dry-run --json' 'motion apply fluid --dry-run --json' 'visual plan --json' 'visual plan --markdown' 'visual audit --json' 'visual audit --markdown')
for case_args in "${CONTROL_CASES[@]}"; do read -r -a argv <<< "${case_args}"; control "${argv[@]}" >/dev/null; done
for script in doctor.sh repair.sh apply-theme-mode.sh status.sh; do [[ -x "${DREAMCODER_DOTS_DIR}/scripts/${script}" ]] || fail "Missing ${script}"; done
ok 'Starship configs and theme health valid'
