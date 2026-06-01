set -gx EDITOR nvim
set -gx VISUAL nvim
set -q COLORTERM; or set -gx COLORTERM truecolor
set -q STARSHIP_CONFIG; or set -gx STARSHIP_CONFIG "$HOME/.config/starship.toml"
set -q DREAMCODER_THEME_MODE; or set -gx DREAMCODER_THEME_MODE light
set -g fish_greeting ""
set -q DREAMCODER_FASTFETCH_ON_START; or set -gx DREAMCODER_FASTFETCH_ON_START 1

fish_add_path -g "$HOME/.local/bin" "$HOME/.opencode/bin" "$HOME/.cargo/bin"
fish_add_path -g "$HOME/.volta/bin" "$HOME/.bun/bin"
fish_add_path -g "$HOME/.nix-profile/bin" /nix/var/nix/profiles/default/bin
fish_add_path -g /usr/local/bin "$HOME/.config"

if test -d "$HOME/.bun/bin"
    set -gx BUN_INSTALL "$HOME/.bun"
    fish_add_path -g "$BUN_INSTALL/bin"
end

if status is-interactive
    command -q zoxide; and zoxide init fish | source
end
