if command -v eza &>/dev/null; then
    alias ls='eza --icons --group-directories-first'
    alias ll='eza -l --icons --group-directories-first'
    alias la='eza -la --icons --group-directories-first'
elif command -v exa &>/dev/null; then
    alias ls='exa --icons --group-directories-first'
    alias ll='exa -l --icons --group-directories-first'
else
    alias ls='ls --color=auto' alias ll='ls -l --color=auto'
fi
