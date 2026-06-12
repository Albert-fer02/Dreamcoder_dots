# Installing Dreamcoder OS on Linux

## Prerequisites

- Arch Linux, Fedora, or Ubuntu/Debian
- GNU Stow
- Git

## Quick Install

```bash
# Install dependencies
sudo pacman -S stow git  # Arch
sudo dnf install stow git  # Fedora
sudo apt install stow git  # Ubuntu

# Clone and install
git clone https://github.com/dreamcoder08/dreamcoder-dots.git ~/dreamcoder-dots
cd ~/dreamcoder-dots
./scripts/dreamcoder install
```

## Via Homebrew (Linux)

```bash
# Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install Dreamcoder
brew install dreamcoder08/tap/dreamcoder-dots
dreamcoder-dots
```
