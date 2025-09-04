# =====================================================
# 🚀 DREAMCODER ZSHRC - CONFIGURACIÓN OPTIMIZADA
# =====================================================
# Configuración de ZSH optimizada para desarrollo y productividad
# Optimizada para Arch Linux con herramientas modernas

export EDITOR=nvim
export ZSH="$HOME/.oh-my-zsh"

# =====================================================
# 🎯 PATH OPTIMIZADO
# =====================================================
# PATH base del sistema
export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

# Función para agregar rutas de forma segura
_safe_path_add() {
    [[ ":$PATH:" != *":$1:"* ]] && [[ -d "$1" ]] && export PATH="$PATH:$1"
}

# Agregar rutas de herramientas modernas (si existen)
_safe_path_add "$HOME/.local/bin"
_safe_path_add "$HOME/.cargo/bin"
_safe_path_add "$HOME/go/bin"
_safe_path_add "$HOME/.bun/bin"
_safe_path_add "$HOME/.fnm"

# =====================================================
# 🌟 PROMPT MODERNO
# =====================================================
# Starship prompt (si está disponible)
if command -v starship &>/dev/null; then
    export STARSHIP_CONFIG="$HOME/.config/starship.toml"
eval "$(starship init zsh)"
else
    # Fallback: prompt moderno para usuario
    PROMPT='%F{blue}󰣇%f %F{cyan}%n@%m%f %F{yellow}%~%f %F{green}✓%f
%F{blue}❯%f '
fi

# =====================================================
# 📊 HISTORIAL OPTIMIZADO
# =====================================================
HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000
SAVEHIST=10000

# Opciones de historial
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_NO_FUNCTIONS
setopt HIST_REDUCE_BLANKS
setopt SHARE_HISTORY
setopt APPEND_HISTORY

# =====================================================
# 🎯 PLUGINS OPTIMIZADOS
# =====================================================
plugins=(
    git
    vi-mode
    history-substring-search
    zsh-autosuggestions
    zsh-syntax-highlighting
)

# Inicializar Oh-My-Zsh
if [[ -f "$ZSH/oh-my-zsh.sh" ]]; then
    source "$ZSH/oh-my-zsh.sh"
fi

# =====================================================
# ⚡ HERRAMIENTAS MODERNAS (LAZY LOADING)
# =====================================================

# FZF para búsqueda rápida (solo si está disponible)
if [[ -o interactive ]] && command -v fzf &>/dev/null; then
    source <(fzf --zsh) 2>/dev/null
    
    # Configuración optimizada de FZF
    export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
    export FZF_DEFAULT_OPTS="
        --height=40%
        --layout=reverse
        --border=rounded
        --preview='head -200 {} 2>/dev/null'
        --color=bg+:#1e1e2e,bg:#11111b,spinner:#f5e0dc,hl:#f38ba8"
fi

# Herramientas modernas (solo si están disponibles)
if command -v bat &>/dev/null; then
    alias cat='bat --style=plain --paging=never'
fi

# =====================================================
# ⚡ VI-MODE
# =====================================================
bindkey -v
export KEYTIMEOUT=1

# =====================================================
# 🔧 ALIASES MODERNOS
# =====================================================

# Operaciones de archivos con confirmación
alias rm='rm -i'
alias cp='cp -i'  
alias mv='mv -i'

# Herramientas modernas de listado (si están disponibles)
if command -v eza &>/dev/null; then
    alias ls='eza --icons --group-directories-first'
    alias ll='eza -l --icons --group-directories-first --git'
    alias la='eza -la --icons --group-directories-first --git'
    alias lt='eza --tree --icons --level=2'
else
    # Fallback a ls tradicional
    alias ll='ls -la --color=auto'
    alias la='ls -la --color=auto'
    alias ls='ls --color=auto'
fi

# Herramientas de sistema modernas
if command -v procs &>/dev/null; then
    alias ps='procs --tree'
fi

if command -v duf &>/dev/null; then
    alias df='duf'
fi

if command -v dust &>/dev/null; then
    alias du='dust'
fi

if command -v btm &>/dev/null; then
    alias htop='btm --basic'
    alias top='btm --basic'
fi

# Búsqueda moderna
if command -v rg &>/dev/null; then
    alias grep='rg'
else
    alias grep='grep --color=auto'
fi

if command -v fd &>/dev/null; then
    alias find='fd'
fi

# Navegación rápida
alias ..='cd ..'
alias ...='cd ../..'
alias -- -='cd -'

# Utilidades generales
alias c='clear'
alias h='history | tail -20'
alias reload='source ~/.zshrc && echo "🔄 ZSH reloaded!"'
alias now='date "+%Y-%m-%d %H:%M:%S"'

# =====================================================
# 🚀 HERRAMIENTAS DE DESARROLLO (LAZY LOADING)
# =====================================================

# Node.js tools (solo si están disponibles)
if command -v fnm &>/dev/null; then
    eval "$(fnm env --use-on-cd)"
fi

if command -v bun &>/dev/null; then
    # Bun ya está en PATH, no necesita inicialización adicional
    :
fi

# Navegación inteligente (solo en modo interactivo)
if [[ -o interactive ]] && command -v zoxide &>/dev/null; then
    eval "$(zoxide init zsh)"
fi

# Historial inteligente (solo en modo interactivo)
if [[ -o interactive ]] && command -v mcfly &>/dev/null; then
    eval "$(mcfly init zsh)"
fi

# =====================================================
# 🧹 COMPLETIONES OPTIMIZADAS
# =====================================================
autoload -Uz compinit

# Optimizar carga de completiones
if [[ -n ${ZDOTDIR:-${HOME}}/.zcompdump(#qN.mh+24) ]]; then
    compinit
else
    compinit -C
fi

# Limpiar función temporal
unfunction _safe_path_add 2>/dev/null

# =====================================================
# 🎨 FASTFETCH AUTOMÁTICO
# =====================================================
# Mostrar información del sistema al iniciar (solo en terminales interactivas)
if [[ -o interactive ]] && [[ $(tty) == *"pts"* ]]; then
    if command -v fastfetch &>/dev/null; then
        # Usar configuración personalizada si existe
        if [[ -f "$HOME/.config/fastfetch/config.jsonc" ]]; then
            fastfetch --config "$HOME/.config/fastfetch/config.jsonc" 2>/dev/null || fastfetch --config none
        else
            fastfetch --config none --structure "Title:Separator:OS:Kernel:Uptime:Memory:Disk"
        fi
    fi
fi