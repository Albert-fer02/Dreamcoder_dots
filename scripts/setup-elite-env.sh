#!/bin/bash
# Senior Arch Linux Development Environment Setup
# Aligned with 'War Architecture' & Elite Investor Standards (Feb 2026)

set -e

echo "Starting Environment Hardening & Toolchain Setup..."

# 1. ACTUALIZACIÓN Y SEGURIDAD BASE
echo "Updating system and installing security tools..."
sudo pacman -Syu --noconfirm
sudo pacman -S --needed --noconfirm nftables zram-generator ufw fail2ban

# Configurar Firewall (nftables)
sudo systemctl enable --now nftables
# Configurar ZRAM para performance en compilación (Rust/WASM)
echo -e "[zram0]\nzram-size = min(ram / 2, 4096)\ncompression-algorithm = zstd" | sudo tee /etc/systemd/zram-generator.conf
sudo systemctl daemon-reload
sudo systemctl start /dev/zram0

# 2. PILA TECNOLÓGICA (CORE)
echo "Installing Core Toolchain..."

# Rust (con Rustup para gestión de toolchains y targets)
if ! command -v rustup &> /dev/null; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    source $HOME/.cargo/env
fi
rustup target add wasm32-unknown-unknown

# Bun (Modern Runtime)
curl -fsSL https://bun.sh/install | bash
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# Docker & Docker Compose
sudo pacman -S --needed --noconfirm docker docker-compose
sudo systemctl enable --now docker
sudo usermod -aG docker $USER

# 3. ELITE UI/UX FOUNDATION
echo "Installing premium typography and UI tools..."
sudo pacman -S --needed --noconfirm ttf-inter ttf-jetbrains-mono-nerd noto-fonts-emoji alacritty starship

# Configurar Starship (Prompt Professional)
if [ ! -f $HOME/.config/starship.toml ]; then
    mkdir -p $HOME/.config
    echo 'format = "$all"' > $HOME/.config/starship.toml
fi
echo 'eval "$(starship init bash)"' >> $HOME/.bashrc

echo "----------------------------------------------------"
echo "SETUP COMPLETED SUCCESSFULLY"
echo "Tools Installed: Rust (WASM), Bun, Docker, nftables"
echo "Note: Log out and log back in for docker groups to take effect."
echo "----------------------------------------------------"
