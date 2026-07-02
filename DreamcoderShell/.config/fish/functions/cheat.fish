function cheat --description 'Quick command cheat sheet (tldr wrapper)'
    if test (count $argv) -eq 0
        echo "Usage: cheat <command>"
        echo "Shows simplified man pages via tldr or man."
        return 1
    end
    if command -q tldr
        tldr $argv
    else
        man $argv 2>/dev/null; or echo "cheat: install tldr for better results (brew install tldr)"
    end
end
