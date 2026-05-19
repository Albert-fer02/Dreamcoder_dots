set -gx EDITOR nvim
set -gx VISUAL nvim
set -q COLORTERM; or set -gx COLORTERM truecolor

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
