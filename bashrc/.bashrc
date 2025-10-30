# =====================================================
# 🚀 OPTIMIZED BASHRC CONFIGURATION
# =====================================================
# Performance optimized for Arch Linux
# Portable, modern, and feature-rich
# Based on DreamCoder's ZSH configuration
#
# ⚠️  IMPORTANTE: Este archivo es para BASH, NO para ZSH
# Si ves errores como "command not found: shopt", estás
# ejecutando esto desde ZSH. Para probar, ejecuta: bash
# =====================================================

# Detectar si estamos en ZSH y mostrar advertencia
if [ -n "$ZSH_VERSION" ]; then
    echo "⚠️  ERROR: Estás intentando cargar .bashrc desde ZSH"
    echo "💡 Para probar la configuración de Bash, ejecuta: bash"
    echo "💡 O edita tu ~/.zshrc si quieres usar ZSH"
    return 2>/dev/null || exit
fi

# =====================================================
# 📝 EDITOR CONFIGURATION (Smart Fallback)
# =====================================================
# Editor con fallback inteligente (nvim > vim > nano)
if command -v nvim &>/dev/null; then
    export EDITOR=nvim
elif command -v vim &>/dev/null; then
    export EDITOR=vim
else
    export EDITOR=nano
fi

# =====================================================
# 📁 PATH CONFIGURATION (Guards against duplication)
# =====================================================
_safe_path_add() {
    # Solo agregar si el directorio existe y no está ya en PATH
    [[ -d "$1" ]] && [[ ":$PATH:" != *":$1:"* ]] && export PATH="$PATH:$1"
}

# Base paths
export PATH="/usr/lib/ccache/bin:$PATH"

# User-specific paths
_safe_path_add "$HOME/.cargo/bin"
_safe_path_add "$HOME/.local/bin"
_safe_path_add "$HOME/go/bin"
_safe_path_add "$HOME/.bun/bin"
_safe_path_add "$HOME/.fnm"

# PNPM - Portable para cualquier usuario
export PNPM_HOME="$HOME/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# Project directories - Detección automática de idioma del sistema
if [[ -d "$HOME/Documents" ]]; then
    export PROJECTS_DIR="${PROJECTS_DIR:-$HOME/Documents/Projects}"
elif [[ -d "$HOME/Documentos" ]]; then
    export PROJECTS_DIR="${PROJECTS_DIR:-$HOME/Documentos/PROYECTOS}"
else
    export PROJECTS_DIR="${PROJECTS_DIR:-$HOME/projects}"
fi

# =====================================================
# 📊 HISTORY CONFIGURATION
# =====================================================
export HISTFILE=~/.bash_history
export HISTSIZE=50000
export HISTFILESIZE=50000

# Bash history options
shopt -s histappend        # Append to history file
shopt -s cmdhist           # Save multi-line commands as one
export HISTCONTROL=ignoreboth:erasedups  # Ignore duplicates and spaces
export HISTIGNORE="ls:ll:la:cd:pwd:exit:clear:history"
export HISTTIMEFORMAT="%F %T "

# Directory navigation
shopt -s autocd 2>/dev/null     # Auto cd into directories
shopt -s cdspell 2>/dev/null    # Correct minor cd typos
shopt -s dirspell 2>/dev/null   # Correct directory name typos

# =====================================================
# 🔍 FZF CONFIGURACIÓN PRO (con bat + fallback inteligente)
# =====================================================
_setup_fzf() {
    # Verificar que FZF esté instalado
    if ! command -v fzf &>/dev/null; then
        echo "⚠️  FZF no está instalado. Instálalo con tu gestor de paquetes (ej: apt, pacman, etc.)" >&2
        return
    fi

    # Cargar FZF keybindings y completion
    if [[ -f /usr/share/fzf/key-bindings.bash ]]; then
        source /usr/share/fzf/key-bindings.bash
    elif [[ -f /usr/local/share/fzf/key-bindings.bash ]]; then
        source /usr/local/share/fzf/key-bindings.bash
    elif [[ -f /opt/homebrew/share/fzf/key-bindings.bash ]]; then
        source /opt/homebrew/share/fzf/key-bindings.bash
    fi
    if [[ -f /usr/share/fzf/completion.bash ]]; then
        source /usr/share/fzf/completion.bash
    elif [[ -f /usr/local/share/fzf/completion.bash ]]; then
        source /usr/local/share/fzf/completion.bash
    elif [[ -f /opt/homebrew/share/fzf/completion.bash ]]; then
        source /opt/homebrew/share/fzf/completion.bash
    fi

    # Detectar preview tool (bat > less > cat)
    local preview_cmd
    if command -v bat &>/dev/null; then
        preview_cmd="bat --style=numbers --color=always --paging=never --line-range :2000"
    elif command -v less &>/dev/null; then
        preview_cmd="less"
    else
        preview_cmd="cat"
    fi

    # Preview inteligente (no mostrar binarios)
    local smart_preview
    if command -v file &>/dev/null; then
        smart_preview="[[ \$(file --mime {} 2>/dev/null) =~ text ]] && $preview_cmd {} || echo 'Archivo binario: {}'"
    else
        smart_preview="$preview_cmd {}"
    fi

    # Configuración avanzada de FZF
    export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS \
        --height=90% \
        --layout=reverse \
        --border=rounded \
        --preview=\"$smart_preview\" \
        --preview-window=right:50%:wrap \
        --color=fg:#cdd6f4,bg:#1e1e2e,hl:#f38ba8 \
        --color=fg+:#ffffff,bg+:#313244,hl+:#fab387 \
        --color=info:#89b4fa,prompt:#cba6f7,pointer:#f38ba8,marker:#f9e2af,spinner:#f38ba8,header:#94e2d5"
}

# Ejecutar setup automáticamente
_setup_fzf

# =====================================================
# 🧭 MODERN NAVIGATION TOOLS
# =====================================================

# Zoxide initialization (smart cd replacement)
if command -v zoxide &>/dev/null; then
    eval "$(zoxide init bash --cmd cd)"
    alias z='__zoxide_z'
fi

# Atuin initialization (better history search)
if command -v atuin &>/dev/null; then
    eval "$(atuin init bash --disable-up-arrow)"
fi

# =====================================================
# 🛠️ UTILITY FUNCTIONS
# =====================================================

# Create directory and enter
mkcd() {
    [[ -z "$1" ]] && { echo "Usage: mkcd <directory>"; return 1; }
    mkdir -p "$1" && cd "$1" || return
}

# Universal extract function
extract() {
    [[ ! -f "$1" ]] && { echo "❌ '$1' is not a valid file"; return 1; }
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
    esac
}

# Smart file search (uses fd if available, fallback to find)
find_file() {
    local filename="$1"
    local search_dir="${2:-.}"

    [[ -z "$filename" ]] && { echo "Usage: find_file <name> [directory]"; return 1; }

    if command -v fd >/dev/null 2>&1; then
        fd "$filename" "$search_dir" --type f 2>/dev/null
    else
        command find "$search_dir" -name "*$filename*" -type f 2>/dev/null | head -20
    fi
}

# =====================================================
# 🎯 SAFE ALIASES (Non-destructive)
# =====================================================

# Navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias -- -='cd -'

# File operations with enhanced safety
alias cp='cp -iv'
alias mv='mv -iv'
alias rm='rm -I --preserve-root'
alias chmod='chmod --preserve-root'
alias chown='chown --preserve-root'
alias mkdir='mkdir -pv'

# Backup importantes antes de operaciones peligrosas
bkp() {
    [[ -z "$1" ]] && { echo "Usage: bkp <file/directory>"; return 1; }
    cp -r "$1" "$1.bkp.$(date +%Y%m%d_%H%M%S)"
    echo "✅ Backup created: $1.bkp.$(date +%Y%m%d_%H%M%S)"
}

# Modern ls alternatives (fallback chain)
if command -v eza &>/dev/null; then
    alias ls='eza --icons --group-directories-first'
    alias ll='eza -l --icons --group-directories-first'
    alias la='eza -la --icons --group-directories-first'
    alias tree='eza --tree --icons'
    alias lt='eza --tree --level=1 --icons'
elif command -v exa &>/dev/null; then
    alias ls='exa --icons --group-directories-first'
    alias ll='exa -l --icons --group-directories-first'
    alias la='exa -la --icons --group-directories-first'
    alias tree='exa --tree --icons'
    alias lt='exa --tree --level=1 --icons'
else
    alias ls='ls --color=auto'
    alias ll='ls -l --color=auto'
    alias la='ls -la --color=auto'
    alias lt='ls -la --color=auto'
fi

# =====================================================
# 🔧 MODERN TOOL ALIASES (Safe alternatives)
# =====================================================

# Better cat with syntax highlighting
if command -v bat &>/dev/null; then
    alias cat='bat --style=auto --paging=never'
    alias ccat='command cat'  # Preserve original cat
fi

# Better top/htop
if command -v btop &>/dev/null; then
    alias htop='btop'
    alias top='btop'
elif command -v htop &>/dev/null; then
    alias top='htop'
fi

# Safe modern alternatives
command -v rg &>/dev/null && alias rg='rg --smart-case'
command -v fd &>/dev/null && alias fdfind='fd --hidden --follow'

# =====================================================
# 🐙 GIT ESSENTIALS
# =====================================================
alias g='git'
alias gs='git status'
alias gss='git status -s'
alias ga='git add'
alias gaa='git add -A'
alias gc='git commit -m'
alias gcam='git commit -am'
alias gp='git push'
alias gpl='git pull'
alias gl='git pull'
alias gd='git diff'
alias gco='git checkout'
alias gcheck='git checkout'
alias gb='git branch'
alias glog='git log --oneline -10'
alias gst='git stash'
alias gstash='git stash push -m'
alias gpop='git stash pop'
alias gsp='git stash; git pull'
alias gfo='git fetch origin'
alias gcredential='git config credential.helper cache'
alias gpsup='git push --set-upstream origin $(git branch --show-current 2>/dev/null || echo main)'
alias gpull='git pull origin $(git branch --show-current 2>/dev/null || echo main)'
alias gclean='git clean -fd'
alias greset='git reset --hard HEAD'

# =====================================================
# 🐳 DOCKER ESSENTIALS
# =====================================================
if command -v docker &>/dev/null; then
    alias d='docker'
    alias dc='docker-compose'
    alias dps='docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"'
    alias di='docker images --format "table {{.Repository}}\t{{.Tag}}\t{{.Size}}"'
    alias dclean='docker system prune -af'
    alias dlogs='docker logs -f'
fi

# =====================================================
# 📦 PACKAGE MANAGERS MODERNOS
# =====================================================
command -v pnpm &>/dev/null && alias pn='pnpm'
command -v yarn &>/dev/null && alias y='yarn'
command -v bun &>/dev/null && alias b='bun'

# =====================================================
# 💻 SYSTEM UTILITIES
# =====================================================
alias c='clear'
alias h='history'
alias nf='fastfetch'
alias pf='fastfetch'
alias ff='fastfetch'
alias v='$EDITOR'
alias vim='$EDITOR'
alias df='df -h'
alias du='du -h'
alias free='free -h'
alias myip='curl -s ifconfig.me'
alias localip="ip route get 1.1.1.1 2>/dev/null | awk '{print \$7}' | head -1"
alias reload='source ~/.bashrc && echo "🔄 Bash reloaded!"'
alias now='date "+%Y-%m-%d %H:%M:%S"'

# Herramientas de red y sistema
alias ports='ss -tuln | grep LISTEN'
if command -v lsof &>/dev/null; then
    alias listening='lsof -i -P -n | grep LISTEN'
fi
alias connections='ss -tuln'
alias netstat='ss -tuln'
alias wifi='nmtui'

# =====================================================
# 🔧 DEVELOPMENT ENHANCED
# =====================================================
alias py='python3'
alias serve='python3 -m http.server'
alias serve-php='php -S localhost:8000'

# Node.js aliases mejorados
if command -v npm &>/dev/null; then
    alias ni='npm install'
    alias nr='npm run'
    alias nrs='npm run start'
    alias nrd='npm run dev'
    alias nrb='npm run build'
    alias nrt='npm run test'
    alias npu='npm update'
fi

# =====================================================
# 🖥️ WINDOW MANAGER & SYSTEM SPECIFIC
# =====================================================
alias Qtile='startx'
alias update-grub='sudo grub-mkconfig -o /boot/grub/grub.cfg'
alias shutdown='systemctl poweroff'

# Display resolution - Solo si DisplayPort-0 existe
if command -v xrandr &>/dev/null; then
    if xrandr 2>/dev/null | grep -q "DisplayPort-0 connected"; then
        alias res1='xrandr --output DisplayPort-0 --mode 2560x1440 --rate 120'
        alias res2='xrandr --output DisplayPort-0 --mode 1920x1080 --rate 120'
    fi
fi

# Keyboard layout - Descomentar si usas teclado alemán
# alias setkb='setxkbmap de;echo "Keyboard set back to de."'

# =====================================================
# 🚀 PRODUCTIVITY FUNCTIONS
# =====================================================

# Workspace inteligente para proyectos
projects() {
    local project_dir="${PROJECTS_DIR:-$HOME/Documents/Projects}"
    if [[ -d "$project_dir" ]]; then
        cd "$project_dir" && ls -la
    else
        echo "📁 Projects directory not found: $project_dir"
        echo "💡 Set PROJECTS_DIR environment variable"
    fi
}

# Función cd inteligente con auto-detección
smart_cd() {
    builtin cd "$@" || return

    # Auto-activar entornos virtuales Python
    if [[ -f "./venv/bin/activate" ]]; then
        echo "🐍 Activating Python virtual environment"
        source ./venv/bin/activate
    elif [[ -f "./.venv/bin/activate" ]]; then
        echo "🐍 Activating Python virtual environment"
        source ./.venv/bin/activate
    fi

    # Detectar proyectos Node.js
    if [[ -f "package.json" && ! -d "node_modules" ]]; then
        echo "📦 Node.js project detected. Run: npm install"
    fi

    # Detectar proyectos Rust
    if [[ -f "Cargo.toml" && ! -d "target" ]]; then
        echo "🦀 Rust project detected. Run: cargo build"
    fi

    # Detectar repositorios Git
    if [[ -d ".git" ]]; then
        git status -s 2>/dev/null | head -5
    fi
}

# Alias para usar smart_cd como cd (solo si zoxide no está instalado)
if ! command -v zoxide &>/dev/null; then
    alias cd='smart_cd'
fi

# Función para crear proyectos rápidos
newproject() {
    [[ -z "$1" ]] && { echo "Usage: newproject <project-name> [type]"; return 1; }

    local project_name="$1"
    local project_type="${2:-basic}"
    local project_dir="${PROJECTS_DIR:-$HOME/Documents/Projects}/$project_name"

    mkdir -p "$project_dir"
    cd "$project_dir"

    case "$project_type" in
        "node"|"js")
            npm init -y
            echo "node_modules/" > .gitignore
            echo "📦 Node.js project created"
            ;;
        "python"|"py")
            python3 -m venv venv
            echo "venv/" > .gitignore
            echo "__pycache__/" >> .gitignore
            echo "*.pyc" >> .gitignore
            echo "🐍 Python project created"
            ;;
        "rust")
            cargo init
            echo "🦀 Rust project created"
            ;;
        *)
            git init
            touch README.md
            echo "📁 Basic project created"
            ;;
    esac

    git init 2>/dev/null
    echo "✅ Project '$project_name' created at: $project_dir"
}

# Función para limpiar archivos temporales
cleantemp() {
    echo "🧹 Cleaning temporary files..."
    find . -name ".DS_Store" -delete 2>/dev/null
    find . -name "Thumbs.db" -delete 2>/dev/null
    find . -name "*.tmp" -delete 2>/dev/null
    find . -name "*~" -delete 2>/dev/null
    echo "✅ Temporary files cleaned"
}

# =====================================================
# 🎨 PROMPT - STARSHIP
# =====================================================
# Starship provides a modern, fast, and customizable prompt
if command -v starship &>/dev/null; then
    eval "$(starship init bash)"
else
    # Fallback simple prompt if starship not installed
    PS1='\[\e[0;36m\]\u\[\e[0m\] \[\e[0;34m\]\w\[\e[0m\] \[\e[0;32m\]❯\[\e[0m\] '
fi

# =====================================================
# 🎉 AUTOSTART
# =====================================================
# Show fastfetch only in terminal sessions (not in scripts)
if [[ -t 0 ]]; then
    command -v fastfetch &>/dev/null && fastfetch
fi

# =====================================================
# 🧹 CLEANUP
# =====================================================
# Unset helper functions to keep environment clean
unset -f _safe_path_add _setup_fzf 2>/dev/null

# =====================================================
# ✨ DREAMCODER DOTFILES - BASH CONFIGURATION
# =====================================================
# Version: 3.1.0
# Portable, modern, and production-ready
# Designed for Arch Linux but works on any Linux distribution
#
# Features:
# - Smart editor fallback (nvim → vim → nano)
# - Modern CLI tools (bat, eza, fd, rg, zoxide, atuin)
# - FZF integration with bat preview
# - Comprehensive git aliases
# - Docker utilities
# - Smart project detection
# - Language-aware PROJECTS_DIR
# - Safe file operations
# - Productivity functions
#
# 🌌 "Code is poetry written in light and logic"
# =====================================================
