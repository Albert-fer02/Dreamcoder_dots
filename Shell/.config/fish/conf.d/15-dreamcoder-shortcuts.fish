# Dreamcoder terminal shortcuts.
if status is-interactive
    alias c='clear'
    alias cls='clear'
    alias q='exit'

    set -q DREAMCODER_DOTS_DIR; or set -gx DREAMCODER_DOTS_DIR $HOME/Documents/PROYECTOS/dreamcoder-dots

    # Dreamcoder theme switcher — updates shell env vars after sync
    function dreamcoder --description 'Switch Dreamcoder theme and reload shell colors'
        # Run the sync script
        $DREAMCODER_DOTS_DIR/scripts/dreamcoder $argv

        # Reload DREAMCODER_THEME_MODE from cache (updated by apply-theme-mode.sh)
        set -l cache_file "$HOME/.cache/dreamcoder/cursor-cli.env"
        if test -f "$cache_file"
            set -l cached_mode (grep DREAMCODER_THEME_MODE "$cache_file" | cut -d= -f2 | tr -d '"')
            test -n "$cached_mode"; and set -gx DREAMCODER_THEME_MODE "$cached_mode"
        end

        # Update BAT_THEME immediately
        switch "$DREAMCODER_THEME_MODE"
            case dark
                set -gx BAT_THEME Dreamcoder-Dark
            case '*'
                set -gx BAT_THEME Dreamcoder-Light
        end

        # Reload LS_COLORS + EZA_COLORS from generated theme file
        set -l theme_dir "$DREAMCODER_DOTS_DIR/themes/dreamcoder"
        set -l ls_file "$theme_dir/ls-colors-dreamcoder-$DREAMCODER_THEME_MODE.sh"
        if test -f "$ls_file"
            set -l ls_val (bash -c "source '$ls_file' 2>/dev/null && echo \$LS_COLORS")
            test -n "$ls_val"; and set -gx LS_COLORS "$ls_val"
            set -l eza_val (bash -c "source '$ls_file' 2>/dev/null && echo \$EZA_COLORS")
            test -n "$eza_val"; and set -gx EZA_COLORS "$eza_val"
        end

        # Reload FZF colors from generated theme file
        set -l fzf_file "$theme_dir/fzf-dreamcoder-$DREAMCODER_THEME_MODE.sh"
        if test -f "$fzf_file"
            set -l fzf_val (bash -c "source '$fzf_file' 2>/dev/null && echo \$FZF_DEFAULT_OPTS")
            test -n "$fzf_val"; and set -gx FZF_DEFAULT_OPTS "$fzf_val"
        end

        echo "🎨 Shell theme reloaded: $DREAMCODER_THEME_MODE mode"
    end

    function mkcd --description 'Create a directory and enter it'
        mkdir -p -- $argv[1]; and cd -- $argv[1]
    end
end
