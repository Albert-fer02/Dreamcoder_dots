#!/bin/bash

# 🎯 Script de prueba para visualizar los prompts

echo "🚀 Prueba de Prompts Dreamcoder Dots"
echo "=================================="
echo

# Mostrar prompt de usuario (fallback)
echo "👤 Prompt Usuario (fallback sin Starship):"
echo -e "\033[34m󰣇\033[0m \033[36mdreamcoder08@hostname\033[0m \033[33m~/Documentos\033[0m \033[32m✓\033[0m"
echo -e "\033[34m❯\033[0m comando_ejemplo"
echo

# Mostrar prompt de root (fallback)  
echo "🔥 Prompt Root (fallback sin Starship):"
echo -e "\033[31m🔥\033[0m \033[33mroot@hostname\033[0m \033[36m/root\033[0m \033[31m✗\033[0m"
echo -e "\033[31m❯\033[0m comando_como_root"
echo

# Simulación con Starship
echo "⭐ Con Starship habilitado:"
echo
echo "👤 Usuario:"
echo -e "\033[34m󰣇\033[0m \033[36mdreamcoder08@hostname\033[0m \033[33m~/proyecto\033[0m \033[35m  main\033[0m \033[32m✓\033[0m"
echo -e "\033[36m❯\033[0m npm run dev"
echo

echo "🔥 Root:"
echo -e "\033[31m🔥\033[0m \033[31mroot@hostname\033[0m \033[36m /etc\033[0m \033[31m✗\033[0m"
echo -e "\033[31m❯\033[0m systemctl restart nginx"
echo

echo "✅ Para aplicar estas configuraciones:"
echo "   ./dreamcoder-setup.sh --configs"
echo
echo "📋 Configuraciones disponibles:"
echo "   • zsh        - Usuario normal"
echo "   • zsh-root   - Superusuario"
echo "   • starship   - Prompt usuario"
echo "   • starship-root - Prompt root"