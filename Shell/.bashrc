# shellcheck shell=bash disable=SC1090,SC1091
set -euo pipefail
[[ -z "${TERM:-}" || "${TERM}" == "dumb" ]] && export TERM="xterm-256color"
export COLORTERM="${COLORTERM:-truecolor}"
[[ "${-}" != *i* ]] && return
shopt -s histappend cmdhist autocd cdspell globstar
export HISTFILE="${HOME}/.bash_history"
HISTSIZE=50000
HISTFILESIZE=100000
export HISTCONTROL=ignoreboth:erasedups
PATH_DIRS=("${HOME}/.local/bin" "${HOME}/.opencode/bin" "${HOME}/.cargo/bin" "${HOME}/.volta/bin" "${HOME}/.nix-profile/bin")
for dir in "${PATH_DIRS[@]}"; do
    [[ -d "${dir}" && ":${PATH}:" != *":${dir}:"* ]] && export PATH="${dir}:${PATH}"
done
BUN_COMPLETION="${HOME}/.bun/_bun"
[[ -f "${BUN_COMPLETION}" ]] && source "${BUN_COMPLETION}"
export BUN_INSTALL="${HOME}/.bun"
[[ -d "${BUN_INSTALL}/bin" ]] && export PATH="${BUN_INSTALL}/bin:${PATH}"
# ── Dreamcoder Theme Hooks ─────────────────────────────────────
_dc_mode="${DREAMCODER_THEME_MODE:-light}"
_dc_theme_dir="${DREAMCODER_DOTS_DIR:-${HOME}/Documents/PROYECTOS/dreamcoder-dots}/themes/dreamcoder"

[[ -f "${_dc_theme_dir}/ls-colors-dreamcoder-${_dc_mode}.sh" ]] && source "${_dc_theme_dir}/ls-colors-dreamcoder-${_dc_mode}.sh"
[[ -f "${_dc_theme_dir}/bat-dreamcoder-${_dc_mode}.sh" ]]    && source "${_dc_theme_dir}/bat-dreamcoder-${_dc_mode}.sh"
[[ -f "${_dc_theme_dir}/fzf-dreamcoder-${_dc_mode}.sh" ]]    && source "${_dc_theme_dir}/fzf-dreamcoder-${_dc_mode}.sh"

SHELL_DIR="${XDG_CONFIG_HOME:-${HOME}/.config}/shell"
for group in core aliases functions; do
    for file in "${SHELL_DIR}/${group}"/*.sh; do [[ -f "${file}" ]] && source "${file}"; done
done
command -v fzf >/dev/null && eval "$(fzf --bash)"
if command -v starship >/dev/null; then
    eval "$(starship init bash)"
    declare -F enable_transience >/dev/null && enable_transience
fi
command -v zoxide >/dev/null && eval "$(zoxide init bash)"
[[ -f "${HOME}/.cargo/env" ]] && source "${HOME}/.cargo/env"
unset _dc_mode _dc_theme_dir PATH_DIRS dir group file BUN_COMPLETION SHELL_DIR
. "$HOME/.cargo/env"
