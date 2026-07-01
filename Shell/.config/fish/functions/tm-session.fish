function tm-session --description 'Quick tmux session picker'
    if not command -q tmux
        echo "tm-session: tmux not installed" >&2
        return 1
    end
    if not command -q fzf
        tmux list-sessions 2>/dev/null; or echo "No tmux sessions"
        return 0
    end

    set -l session (tmux list-sessions -F "#S" 2>/dev/null | fzf --prompt="tmux session> " --height=10)
    if test -n "$session"
        if set -q TMUX
            tmux switch-client -t "$session"
        else
            tmux attach -t "$session"
        end
    end
end
