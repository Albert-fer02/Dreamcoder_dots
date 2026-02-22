# Architecture Overview

## Design Principles

| Principle | Application |
|-----------|-------------|
| **Single Responsibility** | Each file = one purpose (max 30 lines) |
| **DRY** | Shared modules between bash/zsh |
| **Graceful Degradation** | Fallbacks for optional tools |
| **Portability** | No hardcoded paths, works on any Arch |

## Structure

```
~
├── .config/
│   ├── shell/           # Shared shell config
│   │   ├── core/        # PATH, editor, XDG
│   │   ├── aliases/     # Grouped by domain
│   │   └── functions/   # Reusable functions
│   ├── kitty/           # Terminal
│   ├── ghostty/         # Terminal
│   ├── nvim/            # Editor
│   ├── tmux/            # Multiplexer
│   └── git/             # Git config
└── .zshrc / .bashrc     # Entry points (~30 lines each)
```

## Module System

Each module is a folder stowable via `stow <module>`:

```
module/
├── .config/
│   └── appname/
│       └── config
└── .otherfile
```

Stow maps: `module/.config/appname` → `~/.config/appname`

## Loading Order

```
.zshrc / .bashrc
    ↓
core/       (PATH, XDG, editor, projects)
    ↓
aliases/    (navigation, safety, tools, git, docker, dev, arch)
    ↓
functions/  (util, cd, projects, fzf)
    ↓
finalizers  (zoxide, starship, p10k)
```

## Adding New Modules

1. Create folder: `myapp/.config/myapp/config`
2. Add to `MODULES` in Makefile
3. Run: `make stow`

## Adding New Aliases

1. Create: `shell/.config/shell/aliases/mydomain.sh`
2. Add conditional aliases only: `command -v tool && alias ...`
3. No hardcoded paths
