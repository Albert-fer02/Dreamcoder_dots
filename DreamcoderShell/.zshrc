# =====================================================
# 🚀 OPTIMIZED ZSHRC CONFIGURATION
# =====================================================
# Fixed: FZF conflicts, PATH pollution, alias safety, lazy loading
# Performance optimized for Arch Linux

# Editor con fallback inteligente (nvim > vim > nano)
if command -v nvim &>/dev/null; then
    export EDITOR=nvim
elif command -v vim &>/dev/null; then
    export EDITOR=vim
else
    export EDITOR=nano
fi

# =====================================================
# 🧭 ZOXIDE - Inicialización estándar
# =====================================================
if command -v zoxide &>/dev/null; then
    eval "$(zoxide init zsh)"
fi

export ZSH="$HOME/.oh-my-zsh"

# =====================================================
# 📁 PATH CONFIGURATION (Guards against duplication)
# =====================================================
_safe_path_add() {
    [[ -d "$1" ]] && [[ ":$PATH:" != *":$1:"* ]] && export PATH="$PATH:$1"
}

_safe_path_add "$HOME/.cargo/bin"
_safe_path_add "$HOME/.local/bin"
_safe_path_add "$HOME/go/bin"
_safe_path_add "$HOME/.bun/bin"
_safe_path_add "$HOME/.fnm"

# Project directories - Detección automática de idioma del sistema
if [[ -d "$HOME/Documents" ]]; then
    export PROJECTS_DIR="${PROJECTS_DIR:-$HOME/Documents/Projects}"
elif [[ -d "$HOME/Documentos" ]]; then
    export PROJECTS_DIR="${PROJECTS_DIR:-$HOME/Documentos/PROYECTOS}"
else
    export PROJECTS_DIR="${PROJECTS_DIR:-$HOME/projects}"
fi

# =====================================================
# 🎨 OH-MY-ZSH CONFIGURATION
# =====================================================
ZSH_THEME="powerlevel10k/powerlevel10k"

# Let Oh-My-Zsh handle these plugins instead of manual loading
plugins=(
    git
    zsh-autosuggestions
    zsh-syntax-highlighting
    history-substring-search
)

# Initialize Oh-My-Zsh
source $ZSH/oh-my-zsh.sh

# =====================================================
# 📊 HISTORY CONFIGURATION
# =====================================================
HISTFILE=~/.zsh_history
HISTSIZE=50000
SAVEHIST=50000

# Essential history options
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS
setopt HIST_VERIFY
setopt SHARE_HISTORY
setopt APPEND_HISTORY
setopt INC_APPEND_HISTORY
setopt EXTENDED_HISTORY

# Directory navigation
setopt AUTO_CD
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS

# =====================================================
# 🔧 PLUGIN CONFIGURATION (Manual overrides)
# =====================================================

# zsh-autosuggestions customization
if [[ -n "${ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE}" ]]; then
    ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#6c6c6c'
    ZSH_AUTOSUGGEST_STRATEGY=(history completion)
fi

# =====================================================
# 🔍 FZF CONFIGURACIÓN PRO (con bat + fallback inteligente)
# =====================================================
_setup_fzf() {
    local fzf_config="${ARCH_DREAM_ROOT:-$HOME/.config/arch-dream}/modules/core/zsh/plugins/fzf.zsh"

    # 1️⃣ Cargar config personalizada o fallback al sistema
    if [[ -f "$fzf_config" ]]; then
        source "$fzf_config"
    elif command -v fzf &>/dev/null; then
        # Cargar scripts de fzf del sistema
        source <(fzf --zsh 2>/dev/null)
        [[ -f /usr/share/fzf/key-bindings.zsh ]] && source /usr/share/fzf/key-bindings.zsh
        [[ -f /usr/share/fzf/completion.zsh ]] && source /usr/share/fzf/completion.zsh
    else
        echo "⚠️  FZF no está instalado. Instálalo con: sudo pacman -S fzf" >&2
        return
    fi

    # 2️⃣ Detectar preview tool (bat > less > cat)
    local preview_cmd
    if command -v bat &>/dev/null; then
        preview_cmd="bat --style=numbers --color=always --paging=never --line-range :2000"
    elif command -v less &>/dev/null; then
        preview_cmd="less"
    else
        preview_cmd="cat"
    fi

    # 3️⃣ Preview inteligente (no mostrar binarios)
    # Corrige error: $FZF_DEFAULT_OPTS: unknown option: binario:
    # El error ocurre si la preview contiene comillas simples mal escapadas o sintaxis inválida.
    # Usar comillas dobles para la preview y escapar correctamente.
    local smart_preview='[[ $(file --mime {} 2>/dev/null) =~ text ]] && '"$preview_cmd"' {} || echo Archivo\ binario:\ {}'

    # 4️⃣ Configuración avanzada de FZF
    # Evitar sobrescribir FZF_DEFAULT_OPTS
    export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS \
        --height=90% \
        --layout=reverse \
        --border=rounded \
        --preview=\"$smart_preview\" \
        --preview-window=right:50%:wrap \
        --color=fg:#cdd6f4,bg:#1e1e2e,hl:#f38ba8 \
        --color=fg+:#ffffff,bg+:#313244,hl+:#fab387 \
        --color=info:#89b4fa,prompt:#cba6f7,pointer:#f38ba8,marker:#f9e2af,spinner:#f38ba8,header:#94e2d5"

    # 5️⃣ Keybindings mejorados
    bindkey '^T' fzf-file-widget       # Ctrl+T → buscar archivos
    bindkey '^R' fzf-history-widget    # Ctrl+R → buscar en historial
    bindkey '^F' fzf-cd-widget         # Ctrl+F → fuzzy cd
}

# Ejecutar setup automáticamente
_setup_fzf


# =====================================================
# 🧭 MODERN NAVIGATION TOOLS (Lazy loaded)
# =====================================================

# Zoxide está integrado en smart_cd (ver más abajo)

# Atuin lazy loading
_atuin_init() {
    eval "$(atuin init zsh --disable-up-arrow)"
    bindkey '^r' _atuin_search_widget
    unfunction _atuin_init
    _atuin_search_widget
}
command -v atuin &>/dev/null && bindkey '^r' _atuin_init

# =====================================================
# 🛠️ UTILITY FUNCTIONS
# =====================================================

# Create directory and enter
mkcd() {
    [[ -z "$1" ]] && { echo "Usage: mkcd <directory>"; return 1; }
    mkdir -p "$1" && cd "$1" || return
}

# Universal extract
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
alias l='ls -la'

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
elif command -v exa &>/dev/null; then
    alias ls='exa --icons --group-directories-first'
    alias ll='exa -l --icons --group-directories-first'
    alias la='exa -la --icons --group-directories-first'
    alias tree='exa --tree --icons'
else
    alias ll='ls -l --color=auto'
    alias la='ls -la --color=auto'
fi

# =====================================================
# 🔧 MODERN TOOL ALIASES (Safe alternatives)
# =====================================================

# Better alternatives with fallbacks
command -v bat &>/dev/null && alias cat='bat --style=auto --paging=never'

if command -v btop &>/dev/null; then
    alias htop='btop'
    alias top='btop'
elif command -v htop &>/dev/null; then
    alias top='htop'
fi

# Safe modern alternatives (preserve original command names)
command -v rg &>/dev/null && alias rg='rg --smart-case'
command -v fd &>/dev/null && alias fdfind='fd --hidden --follow'

# =====================================================
# 🐙 GIT ESSENTIALS
# =====================================================
alias g='git'
alias gs='git status -s'
alias ga='git add'
alias gc='git commit -m'
alias gp='git push'
alias gl='git pull'
alias gd='git diff'
alias gco='git checkout'
alias gb='git branch'
alias glog='git log --oneline -10'

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
alias df='df -h'
alias du='du -h'
alias free='free -h'
alias myip='curl -s ifconfig.me'
alias localip="ip route get 1.1.1.1 2>/dev/null | awk '{print \$7}' | head -1"
alias reload='source ~/.zshrc && echo "🔄 ZSH reloaded!"'
alias now='date "+%Y-%m-%d %H:%M:%S"'

# Herramientas de red y sistema
alias ports='ss -tuln | grep LISTEN'
alias listening='lsof -i -P -n | grep LISTEN'
alias connections='ss -tuln'
alias netstat='ss -tuln'

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

# Git aliases potenciados
alias gaa='git add -A'
alias gcam='git commit -am'
alias gpsup='git push --set-upstream origin $(git branch --show-current)'
alias gpull='git pull origin $(git branch --show-current)'
alias gstash='git stash push -m'
alias gpop='git stash pop'
alias gclean='git clean -fd'
alias greset='git reset --hard HEAD'

# =====================================================
# 🖥️ WINDOW MANAGER & SYSTEM SPECIFIC
# =====================================================
alias Qtile='startx'
alias update-grub='sudo grub-mkconfig -o /boot/grub/grub.cfg'

# Aliases opcionales - Solo si las dependencias existen
[[ -f ~/.config/ml4w/scripts/figlet.sh ]] && alias ascii='~/.config/ml4w/scripts/figlet.sh'

# Display resolution - Solo si DisplayPort-0 existe
if command -v xrandr &>/dev/null && xrandr 2>/dev/null | grep -q "DisplayPort-0 connected"; then
    alias res1='xrandr --output DisplayPort-0 --mode 2560x1440 --rate 120'
    alias res2='xrandr --output DisplayPort-0 --mode 1920x1080 --rate 120'
fi

# Keyboard layout - Descomentar si usas teclado alemán
# alias setkb='setxkbmap de;echo "Keyboard set back to de."'


# =====================================================
# 🎉 AUTOSTART
# =====================================================
# Show fastfetch only in terminal sessions (not in scripts)
# Muestra fastfetch con un logo aleatorio solo en sesiones de terminal interactivas.
# Esto evita que se ejecute en scripts o sesiones no interactivas.
if [[ -o INTERACTIVE && $(tty) == *"/dev/pts/"* ]]; then
    # Directorio donde se encuentran las imágenes (ruta de producción)
    IMAGE_DIR="$HOME/.config/fastfetch/dreamcoder"

    # Verificar si el directorio de imágenes existe
    if [ -d "$IMAGE_DIR" ]; then
        # Seleccionar una imagen aleatoria (jpg o png) de forma eficiente
        RANDOM_IMAGE=$(find "$IMAGE_DIR" -type f \( -name "*.jpg" -o -name "*.png" \) | shuf -n 1)

        # Ejecutar fastfetch con la imagen aleatoria si se encontró una
        if [ -n "$RANDOM_IMAGE" ]; then
            fastfetch --logo "$RANDOM_IMAGE"
        else
            # Si no hay imágenes, ejecutar fastfetch sin logo
            fastfetch
        fi
    else
        # Si el directorio no existe, ejecutar fastfetch sin logo
        fastfetch
    fi
fi

# =====================================================
# 🚀 PRODUCTIVITY FUNCTIONS
# =====================================================

# Workspace inteligente para proyectos
projects() {
    local project_dir="${PROJECTS_DIR:-$HOME/Documentos/PROYECTOS}"
    if [[ -d "$project_dir" ]]; then
        cd "$project_dir" && ls -la
    else
        echo "📁 Projects directory not found: $project_dir"
        echo "💡 Set PROJECTS_DIR environment variable"
    fi
}

# Zoxide se inicializa al final del archivo

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

# Alias para usar smart_cd como cd (integra zoxide automáticamente)
alias cd='smart_cd'

# Función para crear proyectos rápidos
newproject() {
    [[ -z "$1" ]] && { echo "Usage: newproject <project-name> [type]"; return 1; }
    
    local project_name="$1"
    local project_type="${2:-basic}"
    local project_dir="${PROJECTS_DIR:-$HOME/Documentos/PROYECTOS}/$project_name"
    
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
# 🧹 CLEANUP FUNCTIONS
# =====================================================
unfunction _safe_path_add _setup_fzf 2>/dev/null
# 🚀 POWERLEVEL10K PROMPT - DREAMCODER RAINBOW NEON v3.0
# =====================================================
# Cargar configuración personalizada ANTES de inicializar P10k
if [[ -f ~/.p10k_dreamcoder.zsh ]]; then
    source ~/.p10k_dreamcoder.zsh
elif [[ -f ~/.p10k.zsh ]]; then
    source ~/.p10k.zsh
fi

# Inicializar Powerlevel10k DESPUÉS de cargar la configuración
if typeset -f prompt_powerlevel10k_setup >/dev/null; then
    prompt_powerlevel10k_setup
fi

# pnpm - Portable para cualquier usuario
export PNPM_HOME="$HOME/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end



# --- Senior Engineering Aliases (Dreamcoder Logic) ---
alias pacupd='sudo pacman -Syu'
alias pacinst='sudo pacman -S'
alias pacrem='sudo pacman -Rns'
alias pacfind='pacman -Ss'
alias gs='git status'
alias gp='git push'
alias gpl='git pull'
alias gc='git commit -m'
alias gaa='git add .'
alias gl='git log --oneline --graph --decorate'
alias b='bun'
alias bx='bunx'
alias bd='bun run dev'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../../..'
alias dtree='eza --tree --icons --ignore-glob "target|.git|.cache|node_modules|archive"'
