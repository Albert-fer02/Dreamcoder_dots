# =============================================================================
# Zsh Environment - Always loaded (zshenv is sourced for ALL zsh executions)
# =============================================================================
# This file is for environment variables that MUST be available in ALL shells:
# - Login shells
# - Non-login interactive shells
# - Non-interactive scripts
# =============================================================================

# -----------------------------------------------------------------------------
# XDG Base Directory Specification
# -----------------------------------------------------------------------------
# https://wiki.archlinux.org/title/XDG_Base_Directory
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"
export XDG_RUNTIME_DIR="${XDG_RUNTIME_DIR:-/tmp/user/$UID}"

# Ensure runtime directory exists (required for some tools)
[[ -d "$XDG_RUNTIME_DIR" ]] || mkdir -p "$XDG_RUNTIME_DIR"

# -----------------------------------------------------------------------------
# Locale
# -----------------------------------------------------------------------------
export LANG="${LANG:-en_US.UTF-8}"
export LC_ALL="${LC_ALL:-en_US.UTF-8}"

# -----------------------------------------------------------------------------
# Editor
# -----------------------------------------------------------------------------
# Order: nvim > vim > nano
if command -v nvim &>/dev/null; then
    export EDITOR=nvim
    export VISUAL=nvim
    export GIT_EDITOR=nvim
elif command -v vim &>/dev/null; then
    export EDITOR=vim
    export VISUAL=vim
    export GIT_EDITOR=vim
else
    export EDITOR=nano
    export VISUAL=nano
    export GIT_EDITOR=nano
fi

# -----------------------------------------------------------------------------
# Terminal
# -----------------------------------------------------------------------------
export TERM="${TERM:-xterm-256color}"
export COLORTERM="${COLORTERM:-truecolor}"

# -----------------------------------------------------------------------------
# History
# -----------------------------------------------------------------------------
export HISTFILE="$HOME/.zsh_history"
export HISTSIZE=50000
export SAVEHIST=50000
export HISTDUP=erase          # Erase duplicates when history file grows
export HISTEXCLUDE="'*~|*.bak'"  # Don't save files matching these patterns

# -----------------------------------------------------------------------------
# Development Tools PATH
# -----------------------------------------------------------------------------
# Add user-local binaries (deduplicated in shell configs)
_add_to_path() {
    local dir="$1"
    [[ -d "$dir" && ":$PATH:" != *":$dir:"* ]] && export PATH="$PATH:$dir"
}

# Cargo/Rust
_add_to_path "$HOME/.cargo/bin"

# Local bin
_add_to_path "$HOME/.local/bin"

# OpenCode
_add_to_path "$HOME/.opencode/bin"

# Go
_add_to_path "$HOME/go/bin"

# Bun
_add_to_path "$HOME/.bun/bin"

# npm global (legacy, prefer pnpm)
_add_to_path "$HOME/.npm-global/bin"

# PNPM
export PNPM_HOME="$HOME/.local/share/pnpm"
_add_to_path "$PNPM_HOME"

# NVM (lazy-loaded via shell config, but path here as fallback)
export NVM_DIR="$HOME/.nvm"
[[ -d "$NVM_DIR" ]] && _add_to_path "$NVM_DIR/versions/node/$(nvm version default)/bin"

# Cleanup function
unset -f _add_to_path

# -----------------------------------------------------------------------------
# Language Version Managers (lazy-loaded in .zshrc)
# -----------------------------------------------------------------------------
# Uncomment if using these managers:
# export VOLTA_HOME="$HOME/.volta"
# export RVM_PATH="$HOME/.rvm"
# export PYENV_ROOT="$HOME/.pyenv"

# -----------------------------------------------------------------------------
# Pager
# -----------------------------------------------------------------------------
if command -v less &>/dev/null; then
    export PAGER=less
    export LESS='-R -i -w -M -z-4'
    export LESSHISTFILE=/dev/null  # Don't create .lesshst
fi

# -----------------------------------------------------------------------------
# X11 / Wayland
# -----------------------------------------------------------------------------
# Only set if not already defined (allows override)
if [[ -z "$DISPLAY" && -z "$WAYLAND_DISPLAY" ]]; then
    if [[ -n "$WAYLAND_DISPLAY" ]]; then
        export XDG_CURRENT_DESKTOP=wayland
    elif [[ -n "$DISPLAY" ]]; then
        export XDG_CURRENT_DESKTOP=X11
    fi
fi

# -----------------------------------------------------------------------------
# Application-specific
# -----------------------------------------------------------------------------
# Browser
export BROWSER="${BROWSER:-firefox}"

# Mail
export MAIL="$HOME/Mail"

# -----------------------------------------------------------------------------
# Zsh specific options (for all shells)
# -----------------------------------------------------------------------------
# Immediate history sync (important for CLI tools)
setopt INC_APPEND_HISTORY_TIME

# Don't run PS1 in non-interactive shells
[[ -z "$PS1" ]] && return 0
