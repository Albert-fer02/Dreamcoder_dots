# Atuin shell history — sync + fuzzy search
if status is-interactive; and command -q atuin
    atuin init fish | source
end
