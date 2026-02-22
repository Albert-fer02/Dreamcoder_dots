# Dreamcoder Fish Config
set -g fish_greeting

if status is-interactive
    # Install Fisher if not installed
    if not functions -q fisher
        curl -sL https://git.io/fisher | source
        fisher install jorgebucaran/fisher
    end
end

# Detect Termux
set -l IS_TERMUX 0
if test -n "$TERMUX_VERSION"; or test -d /data/data/com.termux
    set IS_TERMUX 1
end

if test $IS_TERMUX -eq 1
    # Termux - use PREFIX for binaries
    set -x PATH $PREFIX/bin $HOME/.local/bin $HOME/.cargo/bin $PATH
else if test (uname) = Darwin
    # macOS - check for Apple Silicon vs Intel
    if test -f /opt/homebrew/bin/brew
        # Apple Silicon (M1/M2/M3)
        set BREW_BIN /opt/homebrew/bin/brew
    else if test -f /usr/local/bin/brew
        # Intel Mac
        set BREW_BIN /usr/local/bin/brew
    end
    set -x PATH $HOME/.local/bin $HOME/.opencode/bin $HOME/.volta/bin $HOME/.bun/bin $HOME/.nix-profile/bin /nix/var/nix/profiles/default/bin /usr/local/bin $HOME/.config $HOME/.cargo/bin /usr/local/lib/* $PATH
else
    # Linux (Arch/Universal)
    set BREW_BIN /home/linuxbrew/.linuxbrew/bin/brew
    set -x PATH $HOME/.local/bin $HOME/.opencode/bin $HOME/.volta/bin $HOME/.bun/bin $HOME/.nix-profile/bin /nix/var/nix/profiles/default/bin /usr/local/bin $HOME/.config $HOME/.cargo/bin /usr/local/lib/* $PATH
end

# Only eval brew shellenv if brew is installed (not on Termux)
if test $IS_TERMUX -eq 0; and set -q BREW_BIN; and test -f $BREW_BIN
    eval ($BREW_BIN shellenv)
end

# --- Environment Variables ---
set -gx EDITOR nvim
set -gx VISUAL nvim
set -gx TERMINAL ghostty

# --- Initialize tools ---
if type -q starship
    starship init fish | source
end

if type -q zoxide
    zoxide init fish | source
end

if type -q fzf
    fzf --fish | source
end

# --- Senior Engineering Aliases (Dreamcoder Logic) ---
# Package Management
alias pacupd='sudo pacman -Syu'
alias pacinst='sudo pacman -S'
alias pacrem='sudo pacman -Rns'
alias pacfind='pacman -Ss'

# Git shortcuts that prevent common mistakes
alias gs='git status'
alias gp='git push'
alias gpl='git pull'
alias gc='git commit -m'
alias gaa='git add .'
alias gl='git log --oneline --graph --decorate'

# Web Dev shortcuts (Bun)
alias b='bun'
alias bx='bunx'
alias bd='bun run dev'

# Fast Navigation Fix
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../../..'

# Smart ls (eza if available) - using functions to avoid Warp bug
if type -q eza
    function ls; eza $argv; end
    function ll; eza -l $argv; end
    function la; eza -la $argv; end
    function lt; eza --tree $argv; end
    function dtree; eza --tree --ignore-glob "target|.git|.cache|node_modules|archive" $argv; end
else
    alias ls='ls --color=auto'
end

# --- Abbreviations (Fish specific "smart" aliases) ---
abbr -a gco 'git checkout'
abbr -a gcb 'git checkout -b'
abbr -a gm 'git merge'

# --- Colors (Dreamcoder Neon Cyber) ---
set -l foreground F3F6F9
set -l selection 263356
set -l comment 8394A3
set -l red CB7C94
set -l orange DEBA87
set -l yellow FFE066
set -l green B7CC85
set -l purple A3B5D6
set -l cyan 00E5FF  # Dreamcoder Cyan
set -l pink FF8DD7

set -g fish_color_normal $foreground
set -g fish_color_command $cyan
set -g fish_color_keyword $pink
set -g fish_color_quote $yellow
set -g fish_color_redirection $foreground
set -g fish_color_end $orange
set -g fish_color_error $red
set -g fish_color_param $purple
set -g fish_color_comment $comment
set -g fish_color_selection --background=$selection
set -g fish_color_search_match --background=$selection
set -g fish_color_operator $green
set -g fish_color_escape $pink
set -g fish_color_autosuggestion $comment

# Enable vi mode
fish_vi_key_bindings

# Clear screen on start
clear