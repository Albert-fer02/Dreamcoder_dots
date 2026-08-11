# Dreamcoder icon-first terminal listings for Fish.
# eza listings live as abbreviations in 60-abbreviations.fish
# (abbreviations shadow aliases, so aliases here would be dead code).
# This file only keeps plain-ls fallbacks for hosts without eza.
if status is-interactive
    if not command -q eza
        alias ll='ls -lah'
        alias la='ls -lahA'
    end
end
