if status is-interactive
    functions -e fish_prompt 2>/dev/null
    command -q starship; and starship init fish | source
    functions -q enable_transience; and enable_transience
end
