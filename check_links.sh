#!/bin/bash
# DreamCoder Dotfiles - Link Checker
# Verifica que todos los enlaces en el proyecto estén funcionando

# Colores
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

# Lista de URLs a verificar (sin .git en repos de GitHub)
urls=(
    "https://archlinux.org/download/"
    "https://github.com/Albert-fer02/Dreamcoder_dots"
    "https://keepachangelog.com/en/1.0.0/"
    "https://semver.org/spec/v2.0.0.html"
    "https://github.com/Albert-fer02/Dreamcoder_dots/issues"
    "https://starship.rs"
    "https://www.nerdfonts.com/"
    "https://coolors.co"
    "https://www.color-hex.com/color-palette/1013636"
    "https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh"
    "https://github.com/romkatv/powerlevel10k"
)

echo -e "${BLUE}╔════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║   🔗 DREAMCODER LINK CHECKER 🔗       ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════╝${NC}"
echo ""

total=0
ok=0
warnings=0
errors=0

for url in "${urls[@]}"; do
    total=$((total + 1))

    # Seguir redirecciones con -L, timeout de 5 segundos
    status=$(curl -s -L -o /dev/null -w "%{http_code}" --connect-timeout 5 --max-time 10 "$url" 2>/dev/null || echo "000")

    # Códigos 2xx y 3xx son válidos
    if [ "$status" = "200" ] || [ "$status" = "000" ]; then
        if [ "$status" = "200" ]; then
            echo -e "${GREEN}✓${NC} [$status] $url"
            ok=$((ok + 1))
        else
            echo -e "${RED}✗${NC} [TIMEOUT/ERROR] $url"
            errors=$((errors + 1))
        fi
    elif [ "$status" = "301" ] || [ "$status" = "302" ] || [ "$status" = "308" ]; then
        echo -e "${GREEN}✓${NC} [$status] $url (redirección válida)"
        ok=$((ok + 1))
    elif [ "$status" = "403" ] || [ "$status" = "429" ]; then
        echo -e "${YELLOW}⚠${NC} [$status] $url (rate limit/acceso bloqueado)"
        warnings=$((warnings + 1))
    else
        echo -e "${RED}✗${NC} [$status] $url"
        errors=$((errors + 1))
    fi
done

echo ""
echo -e "${BLUE}═══════════════════════════════════════${NC}"
echo -e "Total verificados: $total"
echo -e "${GREEN}✓ OK: $ok${NC}"
if [ $warnings -gt 0 ]; then
    echo -e "${YELLOW}⚠ Advertencias: $warnings${NC}"
fi
if [ $errors -gt 0 ]; then
    echo -e "${RED}✗ Errores: $errors${NC}"
fi
echo -e "${BLUE}═══════════════════════════════════════${NC}"

if [ $errors -gt 0 ]; then
    exit 1
else
    exit 0
fi