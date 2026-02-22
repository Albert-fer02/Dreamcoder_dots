[[ -f /etc/arch-release ]] && {
    alias pacupd='sudo pacman -Syu'
    alias pacinst='sudo pacman -S'
    alias pacrem='sudo pacman -Rns'
}
