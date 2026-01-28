# =====================================================
# BASH PROFILE - Login shell configuration
# =====================================================
# This file is sourced by bash for login shells
# It ensures TERM is set before loading .bashrc

# Ensure TERM is set for proper terminal support
export TERM="${TERM:-xterm-256color}"
export COLORTERM="${COLORTERM:-truecolor}"

# Source bashrc if it exists and we're running interactively
if [[ -f "$HOME/.bashrc" ]] && [[ $- == *i* ]]; then
    source "$HOME/.bashrc"
fi
