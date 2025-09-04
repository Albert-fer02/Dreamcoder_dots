# =====================================================
# 🔴 ROOT ZSHRC - ENHANCED SECURE CONFIGURATION
# =====================================================
# Security-focused with productivity tools for system administration
# Optimized for Arch Linux system management

export EDITOR=nvim
export ZSH="/root/.oh-my-zsh"

# Secure PATH - system directories + safe productivity tools
export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

# Safe path additions for productivity tools
_safe_path_add() {
    [[ ":$PATH:" != *":$1:"* ]] && [[ -d "$1" ]] && export PATH="$PATH:$1"
}

# Only add if tools exist and are system-wide
_safe_path_add "/usr/bin"

# =====================================================
# 🛡️ SECURITY-FIRST PROMPT
# =====================================================
# Starship prompt with root-specific config (if available)
if command -v starship &>/dev/null; then
    export STARSHIP_CONFIG="/root/.config/starship.toml"
    eval "$(starship init zsh)"
else
    # Fallback: prompt moderno para root
    PROMPT='%F{red}🔥%f %F{yellow}%n@%m%f %F{cyan}%~%f %F{red}✗%f
%F{red}❯%f '
fi

# =====================================================
# 📊 CONTROLLED HISTORY
# =====================================================
HISTFILE=/root/.zsh_history_root
HISTSIZE=5000
SAVEHIST=5000

# Strict history options
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_NO_FUNCTIONS
setopt HIST_REDUCE_BLANKS
setopt SHARE_HISTORY
setopt APPEND_HISTORY

# =====================================================
# 🎯 SECURE PLUGINS FOR PRODUCTIVITY
# =====================================================
plugins=(
    git
    vi-mode
    history-substring-search  # Safe history navigation
    zsh-autosuggestions
    zsh-syntax-highlighting
)

# Initialize Oh-My-Zsh
source $ZSH/oh-my-zsh.sh

# =====================================================
# 🔧 PRODUCTIVITY TOOLS (SECURE LOADING)
# =====================================================

# FZF for safe file/command searching (if available system-wide)
if [[ -o interactive ]] && command -v fzf &>/dev/null; then
    source <(fzf --zsh) 2>/dev/null
    
    # Conservative FZF config for root
    export FZF_DEFAULT_COMMAND='find . -type f 2>/dev/null | head -1000'
    export FZF_DEFAULT_OPTS="
        --height=40%
        --layout=reverse
        --border=rounded
        --preview='head -50 {} 2>/dev/null'
        --color=bg+:#1e1e2e,bg:#11111b,spinner:#f5e0dc,hl:#f38ba8"
fi

# Modern alternatives (only if installed system-wide)
if command -v bat &>/dev/null; then
    alias cat='bat --style=plain --paging=never'
fi

# =====================================================
# ⚡ VI-MODE
# =====================================================
bindkey -v
export KEYTIMEOUT=1

# =====================================================
# 🔧 ADMIN ALIASES
# =====================================================
# File operations with confirmation
alias rm='rm -i'
alias cp='cp -i'  
alias mv='mv -i'

# Modern file operations (if available)
if command -v eza &>/dev/null; then
    alias ls='eza --icons --group-directories-first'
    alias ll='eza -l --icons --group-directories-first --git'
    alias la='eza -la --icons --group-directories-first --git'
    alias lt='eza --tree --icons --level=2'
else
    # Fallback to traditional ls
    alias ll='ls -la --color=auto'
    alias la='ls -la --color=auto'
    alias ls='ls --color=auto'
fi

# System administration
alias sctl='systemctl'
alias jctl='journalctl'
alias logs='journalctl -f'
alias services='systemctl list-units --type=service --state=running'
alias failed='systemctl list-units --failed'

# Network and process monitoring (modern tools if available)
alias ports='ss -tulpn'
if command -v procs &>/dev/null; then
    alias procs='procs --tree'
    alias ps='procs'
else
    alias procs='ps auxf'
fi

if command -v duf &>/dev/null; then
    alias disk='duf'
    alias df='duf'
else
    alias disk='df -h'
fi

if command -v dust &>/dev/null; then
    alias usage='dust'
    alias du='dust'
else
    alias usage='du -sh * 2>/dev/null | sort -hr'
fi

if command -v btm &>/dev/null; then
    alias htop='btm --basic'
    alias top='btm --basic'
fi

alias mem='free -h'

# Package management (Arch)
alias pac='pacman'
alias pacs='pacman -S'
alias pacu='pacman -Syu'
alias pacr='pacman -Rns'
alias pacq='pacman -Q'
alias pacorphan='pacman -Rns $(pacman -Qtdq)'

# Quick navigation
alias ..='cd ..'
alias ...='cd ../..'
alias -- -='cd -'

# Modern utilities (if available)
if command -v rg &>/dev/null; then
    alias grep='rg'
else
    alias grep='grep --color=auto'
fi

if command -v fd &>/dev/null; then
    alias find='fd'
fi

# General utilities
alias c='clear'
alias h='history | tail -20'
alias reload='source /root/.zshrc && echo "🔄 Root ZSH reloaded!"'
alias now='date "+%Y-%m-%d %H:%M:%S"'

# Quick system info
alias sysinfo='uname -a && uptime && df -h / && free -h'

# =====================================================
# 🔍 ADMIN FUNCTIONS
# =====================================================
# Show listening ports with process info
listening() {
    echo "🔍 Listening ports:"
    ss -tulpn | grep LISTEN
}

# Quick service status
service-status() {
    [[ -z "$1" ]] && { echo "Usage: service-status <service>"; return 1; }
    systemctl status "$1"
}

# Find large files
large-files() {
    local dir="${1:-.}"
    local size="${2:-100M}"
    echo "🔍 Large files (>${size}) in $dir:"
    if command -v fd &>/dev/null; then
        fd --type f --size +${size} --exec ls -lh {} \; "${dir}" 2>/dev/null | sort -k5 -hr
    else
        find "$dir" -type f -size +${size} -exec ls -lh {} \; 2>/dev/null | sort -k5 -hr
    fi
}

# System health check
health-check() {
    echo "🏥 System Health Check"
    echo "===================="
    echo "📊 Load Average: $(uptime | awk -F'load average:' '{ print $2 }')"
    echo "💾 Memory Usage: $(free | grep Mem | awk '{printf "%.1f%%", $3/$2 * 100.0}')"
    echo "💿 Disk Usage: $(df -h / | awk 'NR==2{printf "%s", $5}')"
    echo "🔥 Temperature: $(sensors 2>/dev/null | grep -E 'Core|temp' | head -1 || echo 'N/A')"
    echo "⏰ Uptime: $(uptime -p)"
}

# Clean system logs
clean-logs() {
    echo "🧹 Cleaning system logs..."
    journalctl --vacuum-time=7d
    journalctl --vacuum-size=500M
    echo "✅ Logs cleaned!"
}

# Find config files
find-config() {
    [[ -z "$1" ]] && { echo "Usage: find-config <pattern>"; return 1; }
    echo "🔍 Searching config files for: $1"
    if command -v rg &>/dev/null; then
        rg "$1" /etc/ --type-add 'config:*.{conf,cfg,ini,yaml,yml,toml}' -t config 2>/dev/null
    else
        grep -r "$1" /etc/ --include="*.conf" --include="*.cfg" --include="*.ini" 2>/dev/null
    fi
}

# =====================================================
# 🧹 OPTIMIZED COMPLETIONS
# =====================================================
autoload -Uz compinit

# Speed up completions
if [[ -n ${ZDOTDIR:-${HOME}}/.zcompdump(#qN.mh+24) ]]; then
    compinit
else
    compinit -C
fi

# Cleanup temporary functions
unfunction _safe_path_add 2>/dev/null

# =====================================================
# 🎯 ROOT CONFIGURATION COMPLETE
# =====================================================
# Root configuration loaded successfully
# All administrative tools and aliases are available