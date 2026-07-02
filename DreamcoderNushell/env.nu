# Nushell Environment Config File — Dreamcoder Dots
#
# version = "0.99.1"

def create_left_prompt [] {
    let dir = match (do --ignore-errors { $env.PWD | path relative-to $nu.home-path }) {
        null => $env.PWD
        '' => '~'
        $relative_pwd => ([~ $relative_pwd] | path join)
    }

    let path_color = (if (is-admin) { ansi red_bold } else { "#d99555" })      # accent
    let separator_color = (if (is-admin) { ansi light_red_bold } else { "#756052" })  # border
    let path_segment = $"($path_color)($dir)(ansi reset)"

    $path_segment | str replace --all (char path_sep) $"($separator_color)(char path_sep)($path_color)"
}

def create_right_prompt [] {
    let time_segment = ([
        (ansi reset)
        "#938274"  # subtle
        (date now | format date '%x %X')
    ] | str join | str replace --regex --all "([/:])" $"#d99555${1}#938274" |
        str replace --regex --all "([AP]M)" $"(ansi underline)#938274${1}")

    let last_exit_code = if ($env.LAST_EXIT_CODE != 0) {([
        (ansi rb)
        ($env.LAST_EXIT_CODE)
    ] | str join)
    } else { "" }

    ([$last_exit_code, (char space), $time_segment] | str join)
}

$env.PROMPT_COMMAND = {|| create_left_prompt }
$env.PROMPT_COMMAND_RIGHT = {|| create_right_prompt }
$env.PROMPT_INDICATOR = {|| "#d99555> " }
$env.PROMPT_INDICATOR_VI_INSERT = {|| ": " }
$env.PROMPT_INDICATOR_VI_NORMAL = {|| "> " }
$env.PROMPT_MULTILINE_INDICATOR = {|| "::: " }

$env.ENV_CONVERSIONS = {
    "PATH": {
        from_string: { |s| $s | split row (char esep) | path expand --no-symlink }
        to_string: { |v| $v | path expand --no-symlink | str join (char esep) }
    }
    "Path": {
        from_string: { |s| $s | split row (char esep) | path expand --no-symlink }
        to_string: { |v| $v | path expand --no-symlink | str join (char esep) }
    }
}

$env.NU_LIB_DIRS = [
    ($nu.default-config-dir | path join 'scripts')
    ($nu.data-dir | path join 'completions')
]

$env.NU_PLUGIN_DIRS = [
    ($nu.default-config-dir | path join 'plugins')
]

$env.EDITOR = "nvim"
$env.VISUAL = "nvim"

# Detect Homebrew path (Linux)
let brew_path = if ("/home/linuxbrew/.linuxbrew/bin/brew" | path exists) {
    "/home/linuxbrew/.linuxbrew/bin"
} else { "" }

$env.PATH = (
    $env.PATH
    | split row (char esep)
    | prepend ($env.HOME | path join ".local/bin")
    | prepend (if $brew_path != "" { $brew_path } else { [] })
    | prepend ($env.HOME | path join ".bun/bin")
    | prepend ($env.HOME | path join ".cargo/bin")
    | prepend ($env.HOME | path join ".nix-profile/bin")
    | prepend '/nix/var/nix/profiles/default/bin'
    | append '/usr/local/bin'
)

$env.STARSHIP_CONFIG = $env.HOME | path join ".config/starship.toml"
$env.CARAPACE_BRIDGES = 'zsh,fish,bash,inshellisense'

# Ensure cache dirs exist
let cache_dirs = ["starship", "carapace"]
for dir in $cache_dirs {
    if ((ls ~/.cache | where name == $dir | length) == 0) {
        mkdir $"~/.cache/($dir)"
    }
}

if ((ls ~/.local/share | where name == "atuin" | length) == 0) {
    mkdir ~/.local/share/atuin
}

starship init nu | save -f ~/.cache/starship/init.nu
zoxide init nushell | save -f ~/.zoxide.nu
atuin init nu | save -f ~/.local/share/atuin/init.nu
carapace _carapace nushell | save --force ~/.cache/carapace/init.nu
