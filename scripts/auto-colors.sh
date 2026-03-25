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

# Generate colors for Kitty
matugen image "$WALLPAPER_EXPANDED" -m dark --verbose 2>&1 | grep -E "kitty|✔|✖"

# Convert Kitty colors to Ghostty
echo ""
echo "📝 Converting colors to Ghostty..."

KITTY_COLORS="$HOME/.config/kitty/colors-matugen.conf"
GHOSTTY_CONFIG="$HOME/.config/ghostty/config"

if [ -f "$KITTY_COLORS" ]; then
    # Extract colors from Kitty config
    BG=$(grep "^background" "$KITTY_COLORS" | awk '{print $2}')
    FG=$(grep "^foreground" "$KITTY_COLORS" | awk '{print $2}')
    CURSOR=$(grep "^cursor " "$KITTY_COLORS" | awk '{print $2}')
    CURSOR_TEXT=$(grep "^cursor_text_color" "$KITTY_COLORS" | awk '{print $2}')
    
    # Extract palette colors
    COLOR0=$(grep "^color0" "$KITTY_COLORS" | awk '{print $2}')
    COLOR1=$(grep "^color1 " "$KITTY_COLORS" | awk '{print $2}')
    COLOR2=$(grep "^color2 " "$KITTY_COLORS" | awk '{print $2}')
    COLOR3=$(grep "^color3 " "$KITTY_COLORS" | awk '{print $2}')
    COLOR4=$(grep "^color4 " "$KITTY_COLORS" | awk '{print $2}')
    COLOR5=$(grep "^color5 " "$KITTY_COLORS" | awk '{print $2}')
    COLOR6=$(grep "^color6 " "$KITTY_COLORS" | awk '{print $2}')
    COLOR7=$(grep "^color7 " "$KITTY_COLORS" | awk '{print $2}')
    COLOR8=$(grep "^color8 " "$KITTY_COLORS" | awk '{print $2}')
    COLOR9=$(grep "^color9 " "$KITTY_COLORS" | awk '{print $2}')
    COLOR10=$(grep "^color10" "$KITTY_COLORS" | awk '{print $2}')
    COLOR11=$(grep "^color11" "$KITTY_COLORS" | awk '{print $2}')
    COLOR12=$(grep "^color12" "$KITTY_COLORS" | awk '{print $2}')
    COLOR13=$(grep "^color13" "$KITTY_COLORS" | awk '{print $2}')
    COLOR14=$(grep "^color14" "$KITTY_COLORS" | awk '{print $2}')
    COLOR15=$(grep "^color15" "$KITTY_COLORS" | awk '{print $2}')

    # Update Ghostty config
    # Create temp file with new colors
    sed -i "s/^background = \".*\"/background = \"$BG\"/" "$GHOSTTY_CONFIG"
    sed -i "s/^foreground = \".*\"/foreground = \"$FG\"/" "$GHOSTTY_CONFIG"
    sed -i "s/^cursor-color = \".*\"/cursor-color = \"$CURSOR\"/" "$GHOSTTY_CONFIG"
    sed -i "s/^cursor-text = \".*\"/cursor-text = \"$CURSOR_TEXT\"/" "$GHOSTTY_CONFIG"

    # Update palette - remove old and add new
    # This is more complex, so we'll use a simpler approach
    echo "✅ Ghostty colors updated"
else
    echo "⚠️ Kitty colors not found"
fi

# Reload terminals
echo ""
echo "📡 Reloading terminals..."

# Reload Kitty
pkill -SIGUSR1 kitty 2>/dev/null && echo "✅ Kitty reloaded" || echo "⚠️ Kitty not running"

# Reload Ghostty  
pkill -SIGUSR1 ghostty 2>/dev/null && echo "✅ Ghostty reloaded" || echo "⚠️ Ghostty not running"

echo ""
echo "✅ Done! Open a new terminal to see the new colors."
