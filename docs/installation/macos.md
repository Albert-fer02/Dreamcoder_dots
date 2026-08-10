# Installing Dreamcoder Workbench on macOS

## Prerequisites

- macOS 12+
- Homebrew
- Git

## Install

```bash
brew install dreamcoder08/tap/dreamcoder-dots
dreamcoder-dots
```

## Manual Install

```bash
# Install dependencies
brew install stow git neovim fish starship fzf zoxide

# Clone and install
git clone https://github.com/dreamcoder08/dreamcoder-dots.git ~/dreamcoder-dots
cd ~/dreamcoder-dots
./scripts/dreamcoder install
```
