# =====================================================
# 🚀 ELITE ZSHRC - NO MERCY EDITION 2025
# =====================================================
# Ultimate configuration for Frontend Dev + Red Team
# Every tool is bleeding edge, optimized for maximum productivity

export EDITOR=nvim
export ZSH="$HOME/.oh-my-zsh"

# =====================================================
# 📁 SMART PATH MANAGEMENT
# =====================================================
_safe_path_add() {
    [[ ":$PATH:" != *":$1:"* ]] && export PATH="$PATH:$1"
}

_safe_path_add "$HOME/.cargo/bin"
_safe_path_add "$HOME/.local/bin"
_safe_path_add "$HOME/.bun/bin"

# =====================================================
# 🎨 STARSHIP PROMPT (Replaces Powerlevel10k)
# =====================================================
# Ultra-fast Rust-based prompt
eval "$(starship init zsh)"

# =====================================================
# 🧠 MCFLY - NEURAL COMMAND HISTORY (LAZY LOAD)
# =====================================================
# Machine learning powered history with context awareness
if [[ -o interactive ]] && command -v mcfly &>/dev/null; then
    eval "$(mcfly init zsh)"
    export MCFLY_KEY_SCHEME=vim
    export MCFLY_FUZZY=2
    export MCFLY_RESULTS=50
    export MCFLY_INTERFACE_VIEW=BOTTOM
fi

# =====================================================
# 🎯 OH-MY-ZSH WITH ELITE PLUGINS
# =====================================================
plugins=(
    git
    vi-mode
    history-substring-search
    zsh-autosuggestions
    zsh-syntax-highlighting
)

# Initialize Oh-My-Zsh
source $ZSH/oh-my-zsh.sh

# =====================================================
# 🔧 CUSTOM PLUGINS CONFIGURATION
# =====================================================
# Load custom plugins that are not in the main plugins directory

# ZSH Completions - Load only if needed
if [[ -d "$ZSH/custom/plugins/zsh-completions" ]]; then
    fpath=($ZSH/custom/plugins/zsh-completions/src $fpath)
fi

# Fast Syntax Highlighting - Load asynchronously
if [[ -f "$ZSH/custom/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh" ]]; then
    source "$ZSH/custom/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh" &!
fi

# You Should Use - Load only in interactive mode
if [[ -o interactive ]] && [[ -f "$ZSH/custom/plugins/you-should-use/you-should-use.plugin.zsh" ]]; then
    source "$ZSH/custom/plugins/you-should-use/you-should-use.plugin.zsh"
fi

# Auto Notify - Load only in interactive mode
if [[ -o interactive ]] && [[ -f "$ZSH/custom/plugins/auto-notify/auto-notify.plugin.zsh" ]]; then
    source "$ZSH/custom/plugins/auto-notify/auto-notify.plugin.zsh"
fi

# =====================================================
# ⚡ VI-MODE ADVANCED CONFIGURATION
# =====================================================
# Enable vim keybindings in terminal
bindkey -v
export KEYTIMEOUT=1

# Vim-style cursor shapes
function zle-keymap-select {
    if [[ ${KEYMAP} == vicmd ]] || [[ $1 = 'block' ]]; then
        echo -ne '\e[1 q'
    elif [[ ${KEYMAP} == main ]] || [[ ${KEYMAP} == viins ]] || [[ ${KEYMAP} = '' ]] || [[ $1 = 'beam' ]]; then
        echo -ne '\e[5 q'
    fi
}
zle -N zle-keymap-select

# Better vim mode indicators
VI_MODE_RESET_PROMPT_ON_MODE_CHANGE=true
VI_MODE_SET_CURSOR=true

# =====================================================
# 📊 ULTRA HISTORY CONFIGURATION
# =====================================================
HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000

# Advanced history options
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS
setopt HIST_VERIFY
setopt SHARE_HISTORY
setopt APPEND_HISTORY
setopt INC_APPEND_HISTORY
setopt EXTENDED_HISTORY
setopt HIST_FIND_NO_DUPS
setopt HIST_EXPIRE_DUPS_FIRST

# Directory navigation
setopt AUTO_CD
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_SILENT

# =====================================================
# 🔍 FZF ELITE CONFIGURATION (LAZY LOAD)
# =====================================================
_setup_fzf() {
    if [[ -o interactive ]] && command -v fzf &>/dev/null; then
        source <(fzf --zsh)
        
        # Elite FZF configuration
        export FZF_DEFAULT_COMMAND='fd --type f --strip-cwd-prefix --hidden --follow --exclude .git'
        export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
        export FZF_ALT_C_COMMAND='fd --type d . --strip-cwd-prefix --hidden --follow --exclude .git'
        
        # Optimized FZF configuration for speed
        export FZF_DEFAULT_OPTS="
            --height=60%
            --layout=reverse
            --border=rounded
            --preview-window=right:50%:wrap
            --preview='([[ -d {} ]] && eza --tree --color=always {} | head -100) || (bat --color=always --style=plain --line-range :200 {} 2>/dev/null || cat {} 2>/dev/null)'
            --bind=ctrl-u:preview-half-page-up,ctrl-d:preview-half-page-down
            --color=bg+:#1e1e2e,bg:#11111b,spinner:#f5e0dc,hl:#f38ba8
            --color=fg:#cdd6f4,header:#f38ba8,info:#cba6ac,pointer:#f5e0dc
            --color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6ac,hl+:#f38ba8"
        
        export FZF_CTRL_T_OPTS="--preview 'bat --color=always --style=plain --line-range :200 {} 2>/dev/null || cat {} 2>/dev/null'"
        export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -100'"
    fi
}
_setup_fzf

# =====================================================
# 🧭 ZOXIDE - SMART DIRECTORY JUMPING (LAZY LOAD)
# =====================================================
if [[ -o interactive ]] && command -v zoxide &>/dev/null; then
    eval "$(zoxide init zsh --cmd cd)"
    alias z='__zoxide_z'
    alias zi='__zoxide_zi'
fi

# =====================================================
# 🚀 MODERN NODE.JS ENVIRONMENT (LAZY LOADING)
# =====================================================
# FNM - Ultra-fast Node version manager (lazy load)
if [[ -o interactive ]]; then
    # Load FNM if available
    if [[ -d "$HOME/.local/share/fnm" ]]; then
        export PATH="$HOME/.local/share/fnm:$PATH"
        eval "$(fnm env --use-on-cd)" 2>/dev/null
    fi
    
    # BUN - The fastest JavaScript runtime (lazy load)
    if command -v bun &>/dev/null; then
        [ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"
    fi
fi

# =====================================================
# 🛠️ ELITE UTILITY FUNCTIONS
# =====================================================

# Enhanced mkcd
mkcd() {
    [[ -z "$1" ]] && { echo "Usage: mkcd <directory>"; return 1; }
    mkdir -p "$1" && cd "$1" && echo "📁 Created and entered: $PWD"
}

# Universal extract with progress
extract() {
    [[ ! -f "$1" ]] && { echo "❌ '$1' is not a valid file"; return 1; }
    echo "🗜️ Extracting $1..."
    case "$1" in
        *.tar.bz2)   tar xjf "$1"    ;;
        *.tar.gz)    tar xzf "$1"    ;;
        *.tar.xz)    tar xJf "$1"    ;;
        *.bz2)       bunzip2 "$1"    ;;
        *.rar)       unrar e "$1"    ;;
        *.gz)        gunzip "$1"     ;;
        *.tar)       tar xf "$1"     ;;
        *.tbz2)      tar xjf "$1"    ;;
        *.tgz)       tar xzf "$1"    ;;
        *.zip)       unzip "$1"      ;;
        *.Z)         uncompress "$1" ;;
        *.7z)        7z x "$1"       ;;
        *.xz)        unxz "$1"       ;;
        *)           echo "⚠️ Unsupported format: '$1'" ;;
    esac && echo "✅ Extraction complete!"
}

# Smart file search
ff() {
    [[ -z "$1" ]] && { echo "Usage: ff <pattern> [directory]"; return 1; }
    fd "$1" "${2:-.}" --type f --hidden --follow | head -50
}

# Smart directory search
fd-dir() {
    [[ -z "$1" ]] && { echo "Usage: fd-dir <pattern> [directory]"; return 1; }
    fd "$1" "${2:-.}" --type d --hidden --follow | head -20
}

# =====================================================
# 💻 FRONTEND DEVELOPMENT ARSENAL
# =====================================================

# Project generators
new-react() {
    [[ -z "$1" ]] && { echo "Usage: new-react <project-name>"; return 1; }
    bunx create-react-app "$1" && cd "$1" && code . && echo "⚛️ React project ready!"
}

new-vite() {
    [[ -z "$1" ]] && { echo "Usage: new-vite <project-name>"; return 1; }
    bunx create-vite "$1" && cd "$1" && bun install && code . && echo "⚡ Vite project ready!"
}

new-next() {
    [[ -z "$1" ]] && { echo "Usage: new-next <project-name>"; return 1; }
    bunx create-next-app@latest "$1" && cd "$1" && code . && echo "🔺 Next.js project ready!"
}

# Development utilities
port-check() { lsof -i :$1 }
port-kill() { 
    [[ -z "$1" ]] && { echo "Usage: port-kill <port>"; return 1; }
    kill -9 $(lsof -t -i:$1) 2>/dev/null && echo "🔪 Killed process on port $1"
}

# Performance monitoring
dev-monitor() {
    echo "🔍 Monitoring development environment..."
    btm --basic --group --tree
}

# =====================================================
# 🔴 RED TEAM WARFARE ARSENAL
# =====================================================

# Reconnaissance pipeline
recon() {
    [[ -z "$1" ]] && { echo "Usage: recon <domain>"; return 1; }
    local target="$1"
    local output="${target}_recon_$(date +%Y%m%d_%H%M%S)"
    
    echo "🎯 Starting reconnaissance on $target"
    mkdir -p "$output" && cd "$output"
    
    echo "🔍 Subdomain enumeration..."
    subfinder -silent -d "$target" -o subdomains.txt
    
    echo "🌐 Probing alive hosts..."
    httpx -silent -l subdomains.txt -o alive_hosts.txt
    
    echo "💥 Vulnerability scanning..."
    nuclei -silent -l alive_hosts.txt -o vulnerabilities.txt
    
    echo "📊 Recon complete! Results in $output/"
    ls -la
}

# Advanced port scanning
portscan-stealth() {
    [[ -z "$1" ]] && { echo "Usage: portscan-stealth <target>"; return 1; }
    echo "👻 Stealth scan on $1..."
    nmap -sS -T2 -f --randomize-hosts "$1"
}

portscan-aggressive() {
    [[ -z "$1" ]] && { echo "Usage: portscan-aggressive <target>"; return 1; }
    echo "💀 Aggressive scan on $1..."
    nmap -T4 -A -v -Pn "$1"
}

# Web enumeration
web-enum() {
    [[ -z "$1" ]] && { echo "Usage: web-enum <url>"; return 1; }
    echo "🕷️ Web enumeration on $1..."
    gobuster dir -u "$1" -w /usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt -t 50 -q
}

# DNS enumeration
dns-enum() {
    [[ -z "$1" ]] && { echo "Usage: dns-enum <domain>"; return 1; }
    echo "🔍 DNS enumeration on $1..."
    gobuster dns -d "$1" -w /usr/share/wordlists/amass/subdomains-top1mil-5000.txt -q
}

# =====================================================
# 🎯 ELITE ALIASES
# =====================================================

# Navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias -- -='cd -'
alias ~='cd ~'

# Modern file operations
if command -v eza &>/dev/null; then
    alias ls='eza --icons --group-directories-first'
    alias ll='eza -l --icons --group-directories-first --git'
    alias la='eza -la --icons --group-directories-first --git'
    alias lt='eza --tree --icons --level=3'
    alias lta='eza --tree --icons --level=3 -a'
fi

# Modern alternatives
command -v bat &>/dev/null && alias cat='bat --style=auto --paging=never'
command -v btm &>/dev/null && alias htop='btm' && alias top='btm'
command -v sd &>/dev/null && alias sed='sd'
command -v fd &>/dev/null && alias find='fd'
command -v rg &>/dev/null && alias grep='rg'

# =====================================================
# 🚀 BUN & NODE.JS ALIASES
# =====================================================
alias bn='bun'
alias bi='bun install'
alias br='bun run'
alias bd='bun run dev'
alias bb='bun run build'
alias bt='bun test'
alias bx='bunx'

# npm alternatives
alias ni='bun install'
alias nr='bun run'
alias nrd='bun run dev'
alias nrb='bun run build'

# =====================================================
# 🔴 RED TEAM ALIASES
# =====================================================
alias nuc='nuclei -l'
alias nucfast='nuclei -c 50 -rl 100 -silent'
alias sub='subfinder -silent -d'
alias alive='httpx -silent'
alias probe='httpx -title -status-code -content-length -silent'
alias gobdir='gobuster dir -w /usr/share/wordlists/dirb/common.txt -u'
alias gobdns='gobuster dns -w /usr/share/wordlists/amass/subdomains-top1mil-5000.txt -d'

# Network reconnaissance
alias ports='ss -tuln'
alias myip='curl -s ifconfig.me && echo'
alias localip='ip route get 1.1.1.1 | awk "{print \$7; exit}"'
alias netstat='ss'

# =====================================================
# 🐙 ADVANCED GIT WORKFLOW
# =====================================================
alias g='git'
alias gs='git status --short --branch'
alias ga='git add'
alias gaa='git add --all'
alias gc='git commit -m'
alias gca='git commit --amend'
alias gp='git push'
alias gpo='git push origin'
alias gl='git pull'
alias gd='git diff'
alias gds='git diff --staged'
alias gco='git checkout'
alias gb='git branch -v'
alias glog='git log --oneline --graph --decorate --all -10'
alias gstash='git stash push -m'

# =====================================================
# 🐳 DOCKER ELITE
# =====================================================
if command -v docker &>/dev/null; then
    alias d='docker'
    alias dc='docker-compose'
    alias dps='docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"'
    alias di='docker images --format "table {{.Repository}}\t{{.Tag}}\t{{.Size}}"'
    alias dstop='docker stop $(docker ps -q)'
    alias dclean='docker system prune -af'
fi

# =====================================================
# 💻 SYSTEM MONITORING
# =====================================================
alias c='clear'
alias h='history | tail -20'
alias df='duf'
alias du='dust'
alias free='free -h'
alias ps='procs'
alias net='bandwhich'
alias reload='source ~/.zshrc && echo "🔄 ZSH reloaded!"'
alias now='date "+%Y-%m-%d %H:%M:%S"'

# Performance utilities
alias bench='hyperfine'
alias count='tokei'

# =====================================================
# 🔧 DEVELOPMENT UTILITIES
# =====================================================
alias py='python3'
alias py-serve='python3 -m http.server'
alias serve='bun run dev'

# Just task runner
if command -v just &>/dev/null; then
    alias j='just'
    alias jl='just --list'
fi

# Navi cheatsheets
if command -v navi &>/dev/null; then
    alias cheat='navi'
fi

# =====================================================
# 🎉 AUTOSTART & WELCOME
# =====================================================
# Show system info only in interactive terminals
if [[ $(tty) == *"pts"* ]] && [[ $- == *i* ]]; then
    command -v fastfetch &>/dev/null && fastfetch
fi


# =====================================================
# 🧹 CLEANUP & OPTIMIZATION
# =====================================================
# Clean up temporary functions
unfunction _safe_path_add _setup_fzf 2>/dev/null

# ZSH completion system optimization
autoload -Uz compinit
if [[ -n ${ZDOTDIR:-${HOME}}/.zcompdump(#qN.mh+24) ]]; then
    compinit
else
    compinit -C
fi

