# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Dreamcoder Dotfiles is a minimalist Arch Linux development environment configuration system. It provides automated installation of shell configurations (ZSH/Bash), modern CLI tools (zoxide, fzf, ripgrep, fd, tmux, github-cli, jq, stow, pass, bat, eza, btop), terminal themes, and development utilities with a simple, direct approach.

**Version:** 3.1.0 - Enhanced portability and VM testing support
**Key Features:** 100% portable, automatic fallbacks, hardware detection, verification tools

## Key Commands

### Primary Installation Script (PREFERRED)

```bash
# Default installation with packages
./install.sh

# Skip package installation (if already installed)
./install.sh --skip-packages

# Update from GitHub
./install.sh update

# Verify installation (NEW in v3.1.0)
./verify.sh

# Show help
./install.sh help
```

### Legacy Complex System (AVOID - Over-engineered)

```bash
# Note: The dreamcoder-setup.sh system exists but is unnecessarily complex
# Prefer using install.sh for all operations
./dreamcoder-setup.sh  # Avoid - use install.sh instead
```

## Architecture

### Simple Script-Based Structure (install.sh)

The preferred approach uses a single, straightforward script:

```
install.sh               # Main installation script (251 lines)
├── Arch Linux specific # Focused on single distribution
├── Simple functions    # Direct package installation and configuration
├── Basic backup        # Essential backup functionality
└── Clear error msgs    # Straightforward error handling
```

### Legacy Modular System (DEPRECATED)

**Note: Avoid using the complex lib/ system - it's over-engineered**

```
lib/ (2000+ lines total) # AVOID - Unnecessary complexity
├── core.sh      # Over-engineered core functions
├── distro.sh    # Multi-distro support (not needed for Arch-focused project)
├── backup.sh    # Complex backup system
├── config.sh    # Over-abstracted configuration management
├── tools.sh     # Unnecessarily modular tool installation
└── ui.sh        # Complex menu systems
```

## Key Features (Simplified Approach)

### Package Installation

- Arch Linux focused with pacman
- Essential packages: zsh, git, curl, wget, kitty, fastfetch, nano, starship
- ZSH plugins: autosuggestions, syntax-highlighting
- Modern CLI tools: fzf, bat, eza, fd, ripgrep, zoxide, tmux, github-cli, jq, stow, pass, btop

### Configuration Management

- Direct file copying (no complex symlink systems)
- Automatic backup creation with timestamps
- Broken symlink cleanup

### Shell Setup

- Oh-My-Zsh installation
- PowerLevel10k theme integration
- Automatic shell change to ZSH

## Development Guidelines

### Simplicity First

- Prefer direct solutions over abstractions
- Single script for single purpose
- Avoid unnecessary modularity
- Keep functions focused and clear

### Arch Linux Focus

- Use pacman directly instead of multi-distro abstractions
- Leverage Arch-specific package names
- Don't abstract what doesn't need abstraction

### Error Handling

- Use `set -euo pipefail` for safety
- Provide clear error messages
- Fail fast on critical errors
- Keep logging simple and direct

## File Structure

```
├── install.sh           # Primary installation script
├── zshrc/.zshrc        # ZSH configuration
├── bashrc/.bashrc      # Bash configuration
├── kitty/              # Kitty terminal config
├── tmux/.tmux.conf     # Tmux multiplexor config
├── fastfetch/          # System info config
├── nano/.nanorc        # Nano editor config
├── .p10k.zsh           # PowerLevel10k config
└── p10k_dreamcoder.zsh # Custom P10K theme
```

## PowerLevel10k Configuration

Custom theme with transparent background and vibrant colors optimized for development work.

## Portability Features (v3.1.0)

### Critical Improvements

- **Editor Fallback:** Automatic nvim → vim → nano fallback
- **No Hardcoded Paths:** All paths use $HOME variable
- **Language Detection:** PROJECTS_DIR adapts to system language (Documents/Documentos)
- **Conditional Aliases:** Hardware-specific aliases only activate when hardware exists
- **Git Verification:** Ensures git is available before cloning
- **Nano Backups:** Automatically creates backup directory

### Testing & Verification

- **verify.sh:** Standalone verification script (348 lines)
- **ANALISIS_VM.md:** Complete portability analysis (13 issues identified and fixed)
- **VM_TESTING.md:** Step-by-step VM testing guide

### Compatibility

- ✅ Works on any Arch Linux installation
- ✅ Any username (no hardcoded usernames)
- ✅ Any language (EN/ES auto-detection)
- ✅ Any hardware configuration
- ✅ With or without optional dependencies
