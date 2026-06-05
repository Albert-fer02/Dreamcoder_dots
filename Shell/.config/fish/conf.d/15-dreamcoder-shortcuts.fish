# Dreamcoder terminal shortcuts.
if status is-interactive
    alias c='clear'
    alias cls='clear'
    alias q='exit'

    # Dreamcoder theme switcher
    set -q DREAMCODER_DOTS_DIR; or set -gx DREAMCODER_DOTS_DIR $HOME/Documents/PROYECTOS/dreamcoder-dots
    alias dreamcoder='$DREAMCODER_DOTS_DIR/scripts/dreamcoder'

    function mkcd --description 'Create a directory and enter it'
        mkdir -p -- $argv[1]; and cd -- $argv[1]
    end
end
