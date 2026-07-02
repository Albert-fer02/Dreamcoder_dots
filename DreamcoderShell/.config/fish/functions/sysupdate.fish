function sysupdate --description 'Update all system packages'
    set -l updated 0
    set -l failed 0

    # Arch Linux
    if command -q paru
        echo ":: Updating Arch (paru)..."
        paru -Syu --noconfirm; and set updated (math $updated + 1); or set failed (math $failed + 1)
    else if command -q yay
        echo ":: Updating Arch (yay)..."
        yay -Syu --noconfirm; and set updated (math $updated + 1); or set failed (math $failed + 1)
    else if command -q pacman
        echo ":: Updating Arch (pacman)..."
        sudo pacman -Syu --noconfirm; and set updated (math $updated + 1); or set failed (math $failed + 1)
    end

    # Homebrew
    if command -q brew
        echo ":: Updating Homebrew..."
        brew update && brew upgrade; and set updated (math $updated + 1); or set failed (math $failed + 1)
    end

    # Flatpak
    if command -q flatpak
        echo ":: Updating Flatpaks..."
        flatpak update -y; and set updated (math $updated + 1); or set failed (math $failed + 1)
    end

    # NPM global
    if command -q npm
        echo ":: Updating npm global packages..."
        npm update -g 2>/dev/null; and set updated (math $updated + 1)
    end

    echo ""
    if test $failed -eq 0
        echo "✓ All $updated package managers updated successfully"
    else
        echo "⚠ $updated succeeded, $failed failed" >&2
    end
end
