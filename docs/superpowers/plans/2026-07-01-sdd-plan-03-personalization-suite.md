# SDD Plan 03: Dreamcoder Personalization Suite

> **Goal:** Curate a set of opinionated personalizations that make dreamcoder-dots uniquely productive, beyond what Gentleman.Dots and ML4W provide. Think "what would a senior architect with 15 years of experience want in their dotfiles that isn't in any framework?"
> **Target:** Aliases, functions, keybindings, scripts, and workflow enhancements unique to dreamcoder
> **Priority:** 🟡 HIGH — this is the "secret sauce" that makes dreamcoder YOURS
> **Estimated diff:** ~500 lines across 20+ files

## Philosophy

Gentleman.Dots gives you a Ferrari. ML4W gives you a workshop. dreamcoder gives you the **custom interior** — the ergonomic touches, the shortcuts that save you 5 seconds 50 times a day, the things that make the environment feel like YOURS.

## Scope

### Fish Shell Personalizations

**Existing (improve):**

| File                                  | What it does                | Improvement                               |
| ------------------------------------- | --------------------------- | ----------------------------------------- |
| `conf.d/10-dreamcoder-keyboard.fish`  | Vi mode, keybindings        | Add `jk` → ESC, better vi-mode indicators |
| `conf.d/15-dreamcoder-shortcuts.fish` | Custom shortcuts            | Expand with modern CLI aliases            |
| `conf.d/16-dreamcoder-icons.fish`     | LS_COLORS, icons            | Use dreamcoder palette, add eza colors    |
| `conf.d/20-dreamcoder-prompt.fish`    | Prompt config               | Clean up, add AI session env              |
| `conf.d/30-dreamcoder-fastfetch.fish` | Fastfetch on terminal start | Add timing, conditional (not on SSH)      |

**Functions (NEW):**

| Function          | What it does                                   | Reference                   |
| ----------------- | ---------------------------------------------- | --------------------------- |
| `mkcd.fish`       | `mkdir -p + cd`                                | Common, surprisingly absent |
| `extract.fish`    | Extract ANY archive type                       | 7z, tar.gz, zip, rar, etc.  |
| `cheat.fish`      | Quick cheat sheet (tldr wrapper)               | Better than `man`           |
| `dots.fish`       | `cd` to dreamcoder-dots repo                   | Quick access                |
| `sysupdate.fish`  | Update everything (pacman, AUR, flatpak, brew) | ML4W-like                   |
| `ports.fish`      | Show listening ports                           | Developer essential         |
| `killport.fish`   | Kill process on a port                         | Developer essential         |
| `http.fish`       | HTTP request with syntax highlighting          | httpie wrapper              |
| `logs.fish`       | Tail journalctl with filters                   | Developer essential         |
| `mcfly.fish`      | Better Ctrl+R for history                      | Modern `fzf` history        |
| `tm-session.fish` | Quick tmux session picker                      | fzf-based                   |

**Aliases (NEW):**

```
alias g=git           # exists
alias gs='git status' # exists
alias gp='git push'   # exists
alias gl='git log --oneline --graph' # exists
alias ll='eza -la --icons'  # improve with eza
alias la='eza -a --icons'
alias lt='eza -T --icons'   # tree view
alias cat='bat'       # exists
alias find='fd'       # new
alias grep='rg'       # improve
alias ps='procs'      # modern ps
alias top='btm'       # bottom (modern htop)
alias du='dua'        # modern du
alias ping='gping'    # graphical ping
alias df='duf'        # modern df
alias sed='sd'        # modern sed
alias help='tldr'     # modern man
alias cd='z'          # zoxide
alias cdi='zi'        # zoxide interactive
```

### Zsh Equivalent

- Same aliases in `.zshrc`
- Same functions in a `functions/` directory sourced by `.zshrc`
- Powerlevel10k or Starship prompt (user choice)

### Bash Equivalent

- Same aliases in `.bashrc`
- Same functions

### Tmux Personalizations

| Feature         | Current      | Improvement                             |
| --------------- | ------------ | --------------------------------------- |
| Prefix          | `C-a`        | ✅ Good, keep                           |
| Split           | `\|` and `-` | Change to `v` and `d` (Gentleman-style) |
| Navigation      | `Alt+arrows` | Add `vim-tmux-navigator` integration    |
| Session picker  | None         | Add fzf-based `C-f` session picker      |
| Floating window | None         | Add `Alt+g` for scratch terminal        |
| Resurrect       | None         | Add tmux-resurrect auto-save            |

### Git Config Personalizations

| Feature              | What                                                 |
| -------------------- | ---------------------------------------------------- |
| `delta` as diff tool | Already exists (`delta-dreamcoder-{mode}.gitconfig`) |
| `git lg` alias       | Pretty log with graph                                |
| `git undo`           | Soft reset to previous commit                        |
| `git cleanup`        | Delete merged branches                               |
| `git conflicts`      | List conflicted files                                |
| `git root`           | Show repo root path                                  |
| `includeIf`          | Conditional git config per directory                 |

### Script Improvements

| Script             | What to add                                                         |
| ------------------ | ------------------------------------------------------------------- |
| `doctor.sh`        | Check ALL theme hooks are properly installed, not just colors       |
| `repair.sh`        | Re-stow ALL components, not just hooks                              |
| `status.sh`        | Show full system status: theme mode, installed components, versions |
| `dreamcoder.sh`    | Add `dreamcoder ai-status` subcommand                               |
| `set-wallpaper.sh` | Add wallpaper rotation support                                      |

## Acceptance Criteria

1. All aliases work in fish, zsh, and bash
2. Every function has `--help` or at minimum a comment explaining usage
3. No alias conflicts with existing commands (check with `type`)
4. `eza`, `bat`, `fd`, `rg`, `zoxide` are detected gracefully (no errors if missing)
5. Tmux has vim-tmux-navigator support
6. Git delta uses dreamcoder dark/light colors matching theme mode
7. `dreamcoder doctor` shows green for every expected component

## Tasks

### Task 1: Fish Enhancements

- Create `conf.d/12-dreamcoder-keybindings.fish` (jk→ESC, improved vi-mode)
- Create `functions/mkcd.fish`, `extract.fish`, `cheat.fish`, `dots.fish`
- Create `functions/sysupdate.fish`, `ports.fish`, `killport.fish`
- Create `functions/http.fish`, `logs.fish`, `tm-session.fish`
- Update `conf.d/15-dreamcoder-shortcuts.fish` with modern CLI aliases
- Update `conf.d/16-dreamcoder-icons.fish` with dreamcoder eza/ls colors

### Task 2: Zsh Enhancements

- Same aliases in `.zshrc`
- Create `DreamcoderShell/.config/zsh/functions/` directory
- Source functions from `.zshrc`
- Ensure p10k users can use dreamcoder colors

### Task 3: Bash Enhancements

- Same aliases in `.bashrc`
- Source dreamcoder functions

### Task 4: Tmux Improvements

- Add `vim-tmux-navigator` keybindings
- Add fzf-based session picker (`C-f`)
- Add scratch terminal popup (`Alt-g`)
- Add tmux-resurrect auto-save on `prefix + Ctrl-s`

### Task 5: Script Polish

- Improve `doctor.sh` — check every component, not just colors
- Improve `repair.sh` — reinstall hooks with confirmation
- Improve `status.sh` — show theme mode, component versions, last wallaper change
- Add `dreamcoder ai-status` subcommand

### Task 6: Verification

- Test every alias in every shell
- Test every function with expected args and edge cases
- `dreamcoder doctor` passes
- Tmux navigation works with vim-tmux-navigator

## Risks

- **Shell-specific syntax**: Fish uses `function` keyword, Zsh uses `function` or `name()`, Bash uses `name()`. Each function needs 3 implementations.
- **Modern CLI dependencies**: `eza`, `bat`, `fd`, `rg`, `procs`, `btm`, `dua`, `gping`, `duf`, `sd`, `tldr` — not everyone has these installed. All aliases must gracefully degrade.
- **Tmux plugin dependency**: vim-tmux-navigator and tmux-resurrect require TPM — must be installed first.

## References

- Existing shell configs: `DreamcoderShell/.config/fish/*.fish`, `DreamcoderShell/.bashrc`, `DreamcoderShell/.zshrc`
- Existing Tmux config: `DreamcoderTmux/.tmux.conf`
- Existing scripts: `scripts/doctor.sh`, `repair.sh`, `status.sh`, `dreamcoder.sh`
- Modern CLI alternatives: `eza`, `bat`, `fd`, `rg`, `procs`, `btm`, `dua`, `gping`, `duf`, `sd`, `tldr`, `zoxide`
