# Dreamcoder Nushell Environment Config
# Powered by Softwart Engineering & Rust 🦀

$env.ENV_CONVERSIONS = {
  "PATH": {
    from_string: { |s| $s | split row (char esep) | path expand --no-symlink }
    to_string: { |v| $s | path expand --no-symlink | str join (char esep) }
  }
  "Path": {
    from_string: { |s| $s | split row (char esep) | path expand --no-symlink }
    to_string: { |v| $s | path expand --no-symlink | str join (char esep) }
  }
}

# Directories to search for scripts
$env.NU_LIB_DIRS = [
    ($nu.default-config-dir | path join 'scripts')
]

# Directories to search for plugin binaries
$env.NU_PLUGIN_DIRS = [
    ($nu.default-config-dir | path join 'plugins')
]

# Path setup
$env.PATH = ($env.PATH | split row (char esep) | append [
    ($env.HOME | path join '.local' 'bin'),
    ($env.HOME | path join '.bun' 'bin'),
    ($env.HOME | path join 'bin')
] | uniq)

# Default Editor
$env.EDITOR = "nvim"
$env.VISUAL = "nvim"
