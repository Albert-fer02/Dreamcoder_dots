# shellcheck shell=bash
# shellcheck disable=SC1090,SC1091
[[ -z "${TERM:-}" || "${TERM}" == "dumb" ]] && export TERM="xterm-256color"
export COLORTERM="${COLORTERM:-truecolor}"
[[ "${-}" != *i* ]] && return
shopt -s histappend cmdhist autocd cdspell globstar
export HISTFILE="${HOME}/.bash_history"
HISTSIZE=50000
HISTFILESIZE=100000
export HISTCONTROL=ignoreboth:erasedups
PATH_DIRS=("${HOME}/.local/bin" "${HOME}/.opencode/bin" "${HOME}/.cargo/bin" "${HOME}/.volta/bin" "${HOME}/.nix-profile/bin" "${HOME}/.config")
for dir in "${PATH_DIRS[@]}"; do
    [[ -d "${dir}" && ":${PATH}:" != *":${dir}:"* ]] && export PATH="${dir}:${PATH}"
done
BUN_COMPLETION="${HOME}/.bun/_bun"
[[ -f "${BUN_COMPLETION}" ]] && source "${BUN_COMPLETION}"
export BUN_INSTALL="${HOME}/.bun"
[[ -d "${BUN_INSTALL}/bin" ]] && export PATH="${BUN_INSTALL}/bin:${PATH}"
SHELL_DIR="${XDG_CONFIG_HOME:-${HOME}/.config}/shell"
for group in core aliases functions; do
    for file in "${SHELL_DIR}/${group}"/*.sh; do [[ -f "${file}" ]] && source "${file}"; done
done
command -v fzf >/dev/null && eval "$(fzf --bash)"
command -v starship >/dev/null && eval "$(starship init bash)"
command -v zoxide >/dev/null && eval "$(zoxide init bash)"
[[ -f "${HOME}/.cargo/env" ]] && source "${HOME}/.cargo/env"
unset PATH_DIRS dir group file BUN_COMPLETION SHELL_DIR
