if status is-interactive
    set -l dotfiles "$HOME/.dotfiles"
    set -l config "$dotfiles/Fastfetch/.config/fastfetch/config.jsonc"
    set -l logo "$HOME/.config/dreamcoder/Dreamcoder01.jpg"

    if command -q fastfetch; and test -f "$config"; and test -f "$logo"
        fastfetch --config "$config" --logo "$logo" --logo-recache true
    else if command -q fastfetch
        fastfetch
    end
end
