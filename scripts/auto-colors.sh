#!/bin/bash
# Auto-update terminal colors based on current wallpaper

# Get current wallpaper from swww
WALLPAPER=$(swww query 2>/dev/null | sed 's/.*image: //')

if [ -z "$WALLPAPER" ]; then
    echo "❌ No wallpaper found"
    exit 1
fi

# Expand path (handle spaces)
WALLPAPER_EXPANDED=$(realpath "$WALLPAPER" 2>/dev/null)

if [ -z "$WALLPAPER_EXPANDED" ] || [ ! -f "$WALLPAPER_EXPANDED" ]; then
    echo "❌ Wallpaper file not found: $WALLPAPER"
    exit 1
fi

echo "🎨 Generating colors from: $WALLPAPER_EXPANDED"

# Generate colors for Kitty (verbose to see what happens)
matugen image "$WALLPAPER_EXPANDED" -m dark --verbose 2>&1 | grep -E "kitty|✔|✖"

# Reload terminals
echo ""
echo "📡 Reloading terminals..."

# Reload Kitty
pkill -SIGUSR1 kitty 2>/dev/null && echo "✅ Kitty reloaded" || echo "⚠️ Kitty not running"

# Reload Ghostty  
pkill -SIGUSR1 ghostty 2>/dev/null && echo "✅ Ghostty reloaded" || echo "⚠️ Ghostty not running"

echo ""
echo "✅ Done! Open a new terminal to see the new colors."
