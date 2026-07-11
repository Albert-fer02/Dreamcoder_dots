set -gx EDITOR nvim
set -gx VISUAL nvim
set -q COLORTERM; or set -gx COLORTERM truecolor
set -q STARSHIP_CONFIG; or set -gx STARSHIP_CONFIG "$HOME/.config/starship.toml"
set -q DREAMCODER_THEME_MODE; or set -gx DREAMCODER_THEME_MODE light
set -g fish_greeting ""

# Pre-set TMUX_PLUGIN_MANAGER_PATH for plugins (Kanagawa, etc.) that need it
set -q TMUX_PLUGIN_MANAGER_PATH; or set -gx TMUX_PLUGIN_MANAGER_PATH "$HOME/.tmux/plugins/"
set -q DREAMCODER_FASTFETCH_ON_START; or set -gx DREAMCODER_FASTFETCH_ON_START 1

fish_add_path -g "$HOME/.local/bin" "$HOME/.cargo/bin"
fish_add_path -g "$HOME/.volta/bin" "$HOME/.bun/bin"
fish_add_path -g "$HOME/.nix-profile/bin" /nix/var/nix/profiles/default/bin
fish_add_path -g /usr/local/bin
fish_add_path -g "$HOME/go/bin"

if test -d "$HOME/.bun/bin"
    set -gx BUN_INSTALL "$HOME/.bun"
    fish_add_path -g "$BUN_INSTALL/bin"
end

if status is-interactive
    command -q zoxide; and zoxide init fish | source
end

# Clean PATH: remove stale entries and duplicates
set -gx PATH (string match -v "$HOME/.config" $PATH)
set -gx PATH (string match -v "$HOME/.opencode/bin" $PATH)

set -l seen
set -l clean_path
for dir in $PATH
    if not contains -- $dir $seen
        set -a clean_path $dir
        set -a seen $dir
    end
end
set -gx PATH $clean_path

# Zen Browser - Profile aliases
alias zp="zen-browser -P Personal"
alias zd="zen-browser -P Dev"
alias zf="zen-browser -P Founder"
# Default browser = Zen Personal (for pi login OAuth, git, etc.)
set -gx BROWSER "zen-browser -P Personal"
fish_add_path /home/dreamcoder08/.local/share/npm-global/bin

# OpenAI API key from Codex CLI (for OpenCode openai-codex provider)
# Token expires 2026-07-10. Run `refresh-openai-key` to renew.
# Loaded dynamically from Codex CLI auth in the function below
# Remove this line when the token in Codex auth changes
source (python3 -c "
import json, os, sys
try:
    d = json.load(open(os.path.expanduser('~/.codex/auth.json')))
    token = d['tokens']['access_token']
    print(f'set -gx OPENAI_API_KEY {token}')
except Exception as e:
    print(f'echo \\\"Warning: could not load Codex token: {e}\\\"')
" 2>/dev/null) 2>/dev/null

# Start selected terminal multiplexer (Herdr)
if status is-interactive; and command -q herdr; and not set -q HERDR_ENV; and not set -q TMUX; and not set -q ZELLIJ
    herdr; or echo "⚠️  Herdr failed to start; continuing in Fish."
end
