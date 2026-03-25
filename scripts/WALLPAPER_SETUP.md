# Auto-actualizar colores de terminal cuando cambia el wallpaper

# Opción 1: Agregar a tu script de wallpaper
# Instead of just running swww/hyprpaper, usa:
# ~/.dotfiles/scripts/set-wallpaper.sh /path/to/wallpaper.jpg

# Opción 2: Si usas waybar o otro tool que cambie wallpaper
# Agrega esta línea después de cambiar el wallpaper:
# matugen image "$WALLPAPER" -m dark && pkill -SIGUSR1 kitty

# Wallpapers disponibles:
ls ~/.ml4w-hyprland/*/wallpapers/*.jpg 2>/dev/null | head -5
