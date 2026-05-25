# Dreamcoder interactive Zsh ergonomics.
set -euo pipefail
[[ -o interactive ]] || return

export EDITOR="nvim" VISUAL="nvim" COLORTERM="${COLORTERM:-truecolor}"
typeset -U path PATH
path=("${HOME}/.local/bin" "${HOME}/.opencode/bin" "${HOME}/.cargo/bin" "${HOME}/.volta/bin" "${HOME}/.bun/bin" "${HOME}/.nix-profile/bin" "${HOME}/.config" "${path[@]}")
export LS_COLORS="di=38;5;179:ex=38;5;208:ln=38;5;116:ow=48;5;236;38;5;179:*.tar=38;5;181:*.zip=38;5;181:*.jpg=38;5;108:*.png=38;5;108:*.mp3=38;5;108:*.wav=38;5;108:*.txt=38;5;223:*.md=38;5;223:*.sh=38;5;208"
BUN_INSTALL="${HOME}/.bun"
[[ -s "${BUN_INSTALL}/_bun" ]] && source "${BUN_INSTALL}/_bun"
[[ -d "${BUN_INSTALL}/bin" ]] && path=("${BUN_INSTALL}/bin" "${path[@]}")
export BUN_INSTALL

ZSH="${ZSH:-${HOME}/.oh-my-zsh}"
plugins=(git sudo web-search)
for plugin in zsh-autosuggestions zsh-syntax-highlighting archlinux; do
  [[ -d "${ZSH_CUSTOM:-${ZSH}/custom}/plugins/${plugin}" || -d "${ZSH}/plugins/${plugin}" ]] && plugins+=("${plugin}")
done
[[ -f "${ZSH}/oh-my-zsh.sh" ]] && source "${ZSH}/oh-my-zsh.sh"
HISTSIZE=50000; SAVEHIST=50000; setopt HIST_IGNORE_DUPS SHARE_HISTORY AUTO_CD
shell_dir="${XDG_CONFIG_HOME:-${HOME}/.config}/shell"
for group in core aliases functions; do for file in "${shell_dir}/${group}"/*.sh(N); do [[ -f "${file}" ]] && source "${file}"; done; done
command -v fzf >/dev/null 2>&1 && eval "$(fzf --zsh)"
command -v zoxide >/dev/null 2>&1 && eval "$(zoxide init zsh)"
command -v starship >/dev/null 2>&1 && eval "$(starship init zsh)" && functions -q enable_transience && enable_transience
command -v starship >/dev/null 2>&1 || { [[ -f "${HOME}/.p10k.zsh" ]] && source "${HOME}/.p10k.zsh"; }
[[ -f "${HOME}/.cargo/env" ]] && source "${HOME}/.cargo/env"
[[ "${DREAMCODER_FASTFETCH_ON_START:-0}" == "1" ]] && command -v fastfetch >/dev/null 2>&1 && fastfetch
unset shell_dir group file plugin
