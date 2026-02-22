mkcd() { mkdir -p "$1" && cd "$1"; }
extract() {
    [[ ! -f "$1" ]] && { echo "Not a file: $1"; return 1; }
    case "$1" in
        *.tar.gz) tar xzf "$1" ;; *.tar.bz2) tar xjf "$1" ;;
        *.zip) unzip "$1" ;; *.7z) 7z x "$1" ;;
        *) echo "Unsupported: $1" ;;
    esac
}
bkp() { cp -r "$1" "$1.bkp.$(date +%Y%m%d_%H%M%S)" && echo "Backup created"; }
