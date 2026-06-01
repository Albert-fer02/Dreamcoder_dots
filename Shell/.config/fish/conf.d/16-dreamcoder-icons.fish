# Dreamcoder icon-first terminal listings for Fish.
if status is-interactive
    if command -q eza
        alias ls='eza --icons=always --group-directories-first'
        alias ll='eza --icons=always --group-directories-first --long --git'
        alias la='eza --icons=always --group-directories-first --long --all --git'
        alias tree='eza --icons=always --group-directories-first --tree'
    else
        alias ll='ls -lah'
        alias la='ls -lahA'
    end
end
