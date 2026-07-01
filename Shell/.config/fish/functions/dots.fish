function dots --description 'cd to dreamcoder-dots repo'
    set -l dir $DREAMCODER_DOTS_DIR
    if test -z "$dir"
        set dir "$HOME/Documents/PROYECTOS/dreamcoder-dots"
    end
    if test -d "$dir"
        cd "$dir"
    else
        echo "dots: dreamcoder-dots not found at $dir" >&2
        return 1
    end
end
