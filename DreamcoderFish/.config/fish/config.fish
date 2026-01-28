# Dreamcoder Fish Config (Powered by Softwart Engineering)
# 2026 Standards: Modern, Fast, Human-readable.

if not status --is-interactive
    exit
end

# --- Environment Variables ---
set -gx EDITOR nvim
set -gx VISUAL nvim
set -gx TERMINAL ghostty

# --- PATH Adjustments ---
fish_add_path $HOME/.local/bin
fish_add_path $HOME/bin
fish_add_path $HOME/.bun/bin

# --- Prompt & Modern Integrations ---
if type -q starship
    starship init fish | source
end

if type -q zoxide
    zoxide init fish | source
end

# --- Senior Engineering Aliases (Dreamcoder Logic) ---
# Package Management
alias pacupd='sudo pacman -Syu'
alias pacinst='sudo pacman -S'
alias pacrem='sudo pacman -Rns'
alias pacfind='pacman -Ss'

# Git
alias gs='git status'
alias gp='git push'
alias gpl='git pull'
alias gc='git commit -m'
alias gaa='git add .'
alias gl='git log --oneline --graph --decorate'

# Web Dev (Bun)
alias b='bun'
alias bx='bunx'
alias bd='bun run dev'

# Fast Navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../../..'

# --- Abbreviations (Fish specific "smart" aliases) ---
abbr -a gco 'git checkout'
abbr -a gcb 'git checkout -b'
abbr -a gm 'git merge'

# --- Fisher Plugin Manager Auto-install ---
if not functions -q fisher
    echo "Installing Fisher plugin manager..."
    curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher
    # Suggested plugins:
    # fisher install PatrickF1/fzf.fish
    # fisher install jorgebucaran/nvm.fish
end

# --- Greeting ---
function fish_greeting
    # Custom greeting can go here
end
