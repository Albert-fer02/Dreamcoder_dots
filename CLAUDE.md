# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Dreamcoder Dotfiles is a minimalist Arch Linux development environment configuration system. It provides automated installation of shell configurations (ZSH/Bash), modern CLI tools, terminal themes, and development utilities with a simple, direct approach.

## Key Commands

### Primary Installation Script (PREFERRED)
```bash
# Default installation with packages
./install.sh

# Skip package installation (if already installed)
./install.sh --skip-packages

# Update from GitHub
./install.sh update

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
├── fastfetch/          # System info config
├── nano/.nanorc        # Nano editor config
├── .p10k.zsh           # PowerLevel10k config
└── p10k_dreamcoder.zsh # Custom P10K theme
```

## PowerLevel10k Configuration
Custom theme with transparent background and vibrant colors optimized for development work.