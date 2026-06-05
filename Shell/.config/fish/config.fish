set -gx EDITOR nvim
set -gx VISUAL nvim
set -q COLORTERM; or set -gx COLORTERM truecolor
set -q STARSHIP_CONFIG; or set -gx STARSHIP_CONFIG "$HOME/.config/starship.toml"

# ── Dreamcoder Theme ─────────────────────────────────────
# Priority: 1) env override, 2) cached mode, 3) default dark
set -q DREAMCODER_THEME_MODE; or begin
    set -l cache_file "$HOME/.cache/dreamcoder/cursor-cli.env"
    if test -f "$cache_file"
        source "$cache_file"
    end
    set -q DREAMCODER_THEME_MODE; or set -gx DREAMCODER_THEME_MODE dark
end

set -q DREAMCODER_DOTS_DIR; or set -gx DREAMCODER_DOTS_DIR "$HOME/Documents/PROYECTOS/dreamcoder-dots"
set -g fish_greeting ""
set -q DREAMCODER_FASTFETCH_ON_START; or set -gx DREAMCODER_FASTFETCH_ON_START 1

# ── Theme-aware tool config ──────────────────────────────
switch $DREAMCODER_THEME_MODE
    case dark
        set -gx BAT_THEME Dreamcoder-Dark
    case light
        set -gx BAT_THEME Dreamcoder-Light
end
set -q BAT_STYLE; or set -gx BAT_STYLE "auto,changes,header,grid"
set -q BAT_TABS; or set -gx BAT_TABS "4"

# Source LS_COLORS from dreamcoder theme
set -l dc_theme_dir "$DREAMCODER_DOTS_DIR/themes/dreamcoder"
set -l ls_colors_file "$dc_theme_dir/ls-colors-dreamcoder-$DREAMCODER_THEME_MODE.sh"
if test -f "$ls_colors_file"
    bash -c "source '$ls_colors_file' 2>/dev/null; echo \$LS_COLORS" | read -l ls_colors_val
    test -n "$ls_colors_val"; and set -gx LS_COLORS "$ls_colors_val"
end

# ── PATH (clean, no .config) ─────────────────────────────
fish_add_path -g "$HOME/.local/bin" "$HOME/.opencode/bin" "$HOME/.cargo/bin"
fish_add_path -g "$HOME/.volta/bin" "$HOME/.bun/bin"
fish_add_path -g "$HOME/.nix-profile/bin" /nix/var/nix/profiles/default/bin
fish_add_path -g /usr/local/bin

if test -d "$HOME/.bun/bin"
    set -gx BUN_INSTALL "$HOME/.bun"
    fish_add_path -g "$BUN_INSTALL/bin"
end

# ── Interactive ──────────────────────────────────────────
if status is-interactive
    command -q zoxide; and zoxide init fish | source
end
