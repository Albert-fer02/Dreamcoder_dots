# Editor with fallback
if command -v nvim &>/dev/null; then
    export EDITOR=nvim VISUAL=nvim
elif command -v vim &>/dev/null; then
    export EDITOR=vim VISUAL=vim
else
    export EDITOR=nano VISUAL=nano
fi
