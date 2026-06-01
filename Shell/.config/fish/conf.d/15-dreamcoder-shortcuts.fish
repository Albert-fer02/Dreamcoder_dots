# Dreamcoder terminal shortcuts.
if status is-interactive
    alias c='clear'
    alias cls='clear'
    alias q='exit'

    function mkcd --description 'Create a directory and enter it'
        mkdir -p -- $argv[1]; and cd -- $argv[1]
    end
end
