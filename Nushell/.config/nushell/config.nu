# Dreamcoder Nushell Main Config
# Version: 1.0.0 | 2026 Engineering Standards

# --- UX Settings ---
$env.config = {
    show_banner: false
    ls: {
        use_ls_colors: true
        clickable_links: true
    }
    rm: {
        always_trash: true # Safety first: move to trash instead of permanent delete
    }
    table: {
        mode: rounded # Industrial Cyber aesthetic
    }
    history: {
        max_size: 10000
        sync_on_enter: true
    }
}

# --- Senior Engineering Aliases (Dreamcoder Logic) ---
alias pacupd = sudo pacman -Syu
alias pacinst = sudo pacman -S
alias pacrem = sudo pacman -Rns
alias pacfind = pacman -Ss

# Git (Nushell handles tables natively, so 'gs' is extra useful)
alias gs = git status
alias gp = git push
alias gpl = git pull
alias gaa = git add .
alias gl = git log --oneline --graph --decorate

# Web Dev
alias b = bun
alias bx = bunx
alias bd = bun run dev

# Fast Navigation
alias .. = cd ..
alias ... = cd ../..

# Custom tree alias
alias dtree = eza --tree --icons --ignore-glob "target|.git|.cache|node_modules|archive"

# --- Integrations ---
# Starship
mkdir ($nu.cache-dir | path join "starship")
starship init nu | save -f ($nu.cache-dir | path join "starship" "init.nu")
source ($nu.cache-dir | path join "starship" "init.nu")

# Zoxide
zoxide init nushell | save -f ($nu.cache-dir | path join "zoxide.nu")
source ($nu.cache-dir | path join "zoxide.nu")

# --- Custom Commands ---
def "check system" [] {
    sys | get host | table -e
}
