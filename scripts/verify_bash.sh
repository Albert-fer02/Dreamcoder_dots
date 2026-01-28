#!/bin/bash
# Script para verificar configuraciones de Bash

echo "=== VERIFICACIÓN DE BASH ===" 
echo ""
echo "1. Verificando archivos:"
ls -lh ~/.bashrc ~/.bash_profile 2>/dev/null || echo "Archivos no encontrados"
echo ""

echo "2. Hash MD5 (repo vs instalado):"
md5sum ~/Documents/PROYECTOS/Dreamcoder_dots/bashrc/.bashrc ~/.bashrc 2>/dev/null
echo ""

echo "3. Probando bash interactivo con TERM correcto:"
TERM=xterm-256color COLORTERM=truecolor timeout 2 bash -i -c '
echo "TERM: $TERM"
echo "COLORTERM: $COLORTERM"  
echo "PROMPT_COMMAND: $PROMPT_COMMAND"
echo "PS1 length: ${#PS1}"
if type starship_precmd &>/dev/null; then
    echo "✓ Starship inicializado correctamente"
else
    echo "✗ Starship NO inicializado"
fi
' 2>&1 | grep -v "cannot set terminal\|no job control\|Inappropriate ioctl"
echo ""

echo "4. Cache de fastfetch:"
if [[ -d ~/.cache/fastfetch ]]; then
    echo "⚠ Cache existe - ejecuta 'ffresh' para limpiar"
else
    echo "✓ Cache limpio"
fi
echo ""

echo "5. Imágenes de fastfetch:"
ls ~/.config/fastfetch/dreamcoder/*.jpg 2>/dev/null | wc -l | xargs echo "Imágenes encontradas:"
