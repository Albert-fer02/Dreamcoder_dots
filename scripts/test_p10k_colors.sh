#!/bin/zsh
# Test de colores y glyphs de Powerlevel10k

echo "=== 🎨 TEST DE POWERLEVEL10K - DREAMCODER ===" 
echo ""
echo "1️⃣ Nerd Font Glyphs:"
echo "   OS Icon: "
echo "   Git Branch: "
echo "   Directory: "
echo "   DreamCoder Badge: ⬢"
echo "   Prompt: ❯"
echo "   Error: ✖"
echo ""
echo "2️⃣ Colores disponibles en tu terminal:"
for i in {0..255}; do
    printf "\e[48;5;%sm%3d\e[0m " "$i" "$i"
    if (( (i + 1) % 16 == 0 )); then
        printf "\n"
    fi
done
echo ""
echo "3️⃣ Aplicar configuración:"
echo "   exec zsh     # Reiniciar ZSH"
echo "   source ~/.p10k.zsh  # Recargar configuración"
