export TERM="${TERM:-xterm-256color}"
[[ -f "$HOME/.bashrc" && $- == *i* ]] && source "$HOME/.bashrc"
[[ -f "$HOME/.cargo/env" ]] && source "$HOME/.cargo/env"
