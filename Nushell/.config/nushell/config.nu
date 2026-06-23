# Nushell configuration for Dreamcoder OS
# https://github.com/dreamcoder08/dreamcoder-dots

# Source theme
source $"($env.HOME)/.config/nushell/dreamcoder-($env.DREAMCODER_THEME_MODE).nu"

# Starship prompt
mkdir ~/.cache/starship
$env.STARSHIP_CACHE = $"($env.HOME)/.cache/starship"

# Aliases
alias g = git
alias gs = "git status"
alias gp = "git push"
alias gl = "git log --oneline --graph"
alias ll = "ls -la"
alias la = "ls -a"
alias cat = "bat"
alias find = "fd"
alias grep = "rg"

# Cargo
source "~/.cargo/env.nu"

# Custom completions
def "nu-complete git branches" [] {
    ^git branch | lines | each { |line| $line | str replace '[\*\+] ' '' | str trim }
}

def "nu-complete git subcommands" [] {
    [add, branch, checkout, cherry-pick, clone, commit, diff, fetch, grep, init, log, merge, pull, push, rebase, reset, rm, show, stash, status, tag]
}
