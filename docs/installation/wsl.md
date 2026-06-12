# Installing Dreamcoder OS on Windows WSL

## Prerequisites

- Windows 10/11 with WSL2 enabled
- Ubuntu or Debian on WSL
- GNU Stow

## Install

```bash
# Install dependencies
sudo apt update && sudo apt install -y stow git

# Clone and install
git clone https://github.com/dreamcoder08/dreamcoder-dots.git ~/dreamcoder-dots
cd ~/dreamcoder-dots
./scripts/dreamcoder install
```

## Using Windows Terminal

After install, configure Windows Terminal to use:
- Shell: `wsl -d Ubuntu`
- Font: JetBrainsMono Nerd Font
- Theme: Use the Dreamcoder theme in Windows Terminal settings
