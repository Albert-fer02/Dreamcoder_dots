# Dreamcoder Dots v2.0 Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Transform Dreamcoder Dots into a full OS experience with multi-platform Go installer, 5 new terminal configs, Vim trainer, and comprehensive docs.

**Architecture:** Token-driven theme generation (existing Python engine) + Go binary installer (Bubbletea TUI) + separate AI layer repo. Each terminal config is a renderer module that reads `tokens.json` and outputs mode-specific config files.

**Tech Stack:** Python (theme engine), Go (installer: Bubbletea, Lipgloss, Cobra), Bash (setup scripts), Markdown (docs)

---

## Phase 1: Terminal Configs (Tasks 1-5)

Each task follows the same pattern: create config files + add renderer to theme engine + test generation.

### Task 1: Tmux Config + Theme Renderer

**Files:**
- Create: `Tmux/.tmux.conf`
- Create: `Tmux/.config/tmux/dreamcoder-dark.conf` (generated)
- Create: `Tmux/.config/tmux/dreamcoder-light.conf` (generated)
- Modify: `scripts/dreamcoder_theme/renderers_tmux.py` (extend existing)

- [ ] **Step 1: Create base tmux.conf**

```bash
mkdir -p Tmux/.config/tmux
```

```conf
# Tmux configuration for Dreamcoder OS
# https://github.com/dreamcoder08/dreamcoder-dots

# ─── General ───────────────────────────────────────────
set -g default-terminal "tmux-256color"
set -ag terminal-overrides ",xterm-256color:RGB"
set -g mouse on
set -g history-limit 50000
set -g base-index 1
setw -g pane-base-index 1
set -g renumber-windows on
set -s escape-time 0
set -g focus-events on

# ─── Key Bindings ──────────────────────────────────────
# Prefix: Ctrl+a (like screen)
set -g prefix C-a
unbind C-b
bind C-a send-prefix

# Split panes
bind | split-window -h -c "#{pane_current_path}"
bind - split-window -v -c "#{pane_current_path}"
unbind '"'
unbind %

# Vi mode
setw -g mode-keys vi
bind -T copy-mode-vi v send-keys -X begin-selection
bind -T copy-mode-vi y send-keys -X copy-pipe-and-cancel "xclip -selection clipboard"

# Navigate panes with Alt+arrow
bind -n M-Left select-pane -L
bind -n M-Right select-pane -R
bind -n M-Up select-pane -U
bind -n M-Down select-pane -D

# Reload config
bind r source-file ~/.tmux.conf \; display-message "Config reloaded!"

# ─── Theme (Dreamcoder) ────────────────────────────────
# Auto-detect mode from DREAMCODER_THEME_MODE
if-shell '[ "$DREAMCODER_THEME_MODE" = "light" ]' \
    'source-file ~/.config/tmux/dreamcoder-light.conf' \
    'source-file ~/.config/tmux/dreamcoder-dark.conf'

# ─── Status Bar ────────────────────────────────────────
set -g status-position bottom
set -g status-interval 5
set -g status-justify left
set -g status-left-length 40
set -g status-right-length 60
```

- [ ] **Step 2: Create dark theme conf**

```conf
# Dreamcoder Dark Theme for Tmux
# Auto-generated from tokens.json — do not edit manually

# ─── Colors ────────────────────────────────────────────
set -g status-style "bg=#1a1714,fg=#e8dfd0"
set -g status-left "#[bg=#d99555,fg=#100f0d,bold] #S #[bg=#1a1714,fg=#d99555] "
set -g status-right "#[fg=#5f95ca]#[fg=#e8dfd0] %H:%M #[fg=#c96a45]%Y-%m-%d "

# Window status
setw -g window-status-format "#[fg=#6b5f52] #I:#W "
setw -g window-status-current-format "#[bg=#2a2520,fg=#d99555,bold] #I:#W "

# Pane borders
set -g pane-border-style "fg=#2a2520"
set -g pane-active-border-style "fg=#d99555"

# Messages
set -g message-style "bg=#2a2520,fg=#e8dfd0"
set -g message-command-style "bg=#2a2520,fg=#e8dfd0"

# Mode (copy mode highlight)
setw -g mode-style "bg=#d99555,fg=#100f0d"

# Bell
setw -g window-status-bell-style "bg=#c96a45,fg=#e8dfd0"
```

- [ ] **Step 3: Create light theme conf**

```conf
# Dreamcoder Light Theme for Tmux
# Auto-generated from tokens.json — do not edit manually

# ─── Colors ────────────────────────────────────────────
set -g status-style "bg=#e8dfd0,fg=#17120d"
set -g status-left "#[bg=#824f16,fg=#f3eadc,bold] #S #[bg=#e8dfd0,fg=#824f16] "
set -g status-right "#[fg=#3a7bc8]#[fg=#17120d] %H:%M #[fg=#b85c2a]%Y-%m-%d "

# Window status
setw -g window-status-format "#[fg=#8a7e72] #I:#W "
setw -g window-status-current-format "#[bg=#d9cfc0,fg=#824f16,bold] #I:#W "

# Pane borders
set -g pane-border-style "fg=#d9cfc0"
set -g pane-active-border-style "fg=#824f16"

# Messages
set -g message-style "bg=#d9cfc0,fg=#17120d"
set -g message-command-style "bg=#d9cfc0,fg=#17120d"

# Mode (copy mode highlight)
setw -g mode-style "bg=#824f16,fg=#f3eadc"

# Bell
setw -g window-status-bell-style "bg=#b85c2a,fg=#f3eadc"
```

- [ ] **Step 4: Test theme files exist and are valid**

Run: `cat Tmux/.config/tmux/dreamcoder-dark.conf | head -5`
Expected: Shows Dreamcoder Dark Theme header

Run: `cat Tmux/.config/tmux/dreamcoder-light.conf | head -5`
Expected: Shows Dreamcoder Light Theme header

- [ ] **Step 5: Commit**

```bash
git add Tmux/
git commit -m "feat(tmux): add tmux config with dreamcoder dark/light themes"
```

---

### Task 2: Zellij Config + Theme Renderer

**Files:**
- Create: `Zellij/.config/zellij/config.kdl`
- Create: `Zellij/.config/zellij/dreamcoder-dark.kdl`
- Create: `Zellij/.config/zellij/dreamcoder-light.kdl`
- Create: `Zellij/.config/zellij/layouts/dreamcoder.kdl`

- [ ] **Step 1: Create base config.kdl**

```bash
mkdir -p Zellij/.config/zellij/layouts
```

```kdl
// Zellij configuration for Dreamcoder OS
// https://github.com/dreamcoder08/dreamcoder-dots

env {
    CARGO_INCREMENTAL "0"
}

keybinds {
    shared_except "locked" {
        alt "n" { NewTab; }
        alt "j" { MoveTabLeft; }
        alt "k" { MoveTabRight; }
        alt "1" { GoToTab 1; }
        alt "2" { GoToTab 2; }
        alt "3" { GoToTab 3; }
        alt "4" { GoToTab 4; }
        alt "5" { GoToTab 5; }
        ctrl "t" { ToggleTab; }
    }
    shared_except "locked" "resize" {
        ctrl "b" { SwitchToMode "Resize"; }
    }
    resize {
        "k" { Resize "Up"; }
        "j" { Resize "Down"; }
        "h" { Resize "Left"; }
        "l" { Resize "Right"; }
        ctrl "b" { SwitchToMode "Locked"; }
    }
}

plugins {
    tab-bar { path "tab-bar"; }
    status-bar { path "status-bar"; }
    compact-bar { path "compact-bar"; }
}

// Theme
theme "dreamcoder-dark"
```

- [ ] **Step 2: Create dark theme**

```kdl
// Dreamcoder Dark Theme for Zellij
// Auto-generated from tokens.json — do not edit manually

themes {
    dreamcoder-dark {
        bg "#100f0d"
        fg "#e8dfd0"
        black "#100f0d"
        red "#c96a45"
        green "#7a9e6c"
        yellow "#d99555"
        blue "#5f95ca"
        magenta "#a87cb5"
        cyan "#5f95ca"
        white "#e8dfd0"
        orange "#d99555"
        gray "#6b5f52"

        // UI elements
        border "#2a2520"
        border_active "#d99555"
        border_unfocused "#2a2520"

        // Tab bar
        tab_bar_bg "#1a1714"
        tab_active_bg "#2a2520"
        tab_active_fg "#d99555"
        tab_inactive_bg "#1a1714"
        tab_inactive_fg "#6b5f52"

        // Pane frames
        pane_frame_bg "#1a1714"
        pane_frame_fg "#2a2520"

        // Selection
        selection_bg "#d99555"
        selection_fg "#100f0d"
    }
}
```

- [ ] **Step 3: Create light theme**

```kdl
// Dreamcoder Light Theme for Zellij
// Auto-generated from tokens.json — do not edit manually

themes {
    dreamcoder-light {
        bg "#f3eadc"
        fg "#17120d"
        black "#17120d"
        red "#b85c2a"
        green "#5a7a4c"
        yellow "#824f16"
        blue "#3a7bc8"
        magenta "#7a5c85"
        cyan "#3a7bc8"
        white "#f3eadc"
        orange "#824f16"
        gray "#8a7e72"

        // UI elements
        border "#d9cfc0"
        border_active "#824f16"
        border_unfocused "#d9cfc0"

        // Tab bar
        tab_bar_bg "#e8dfd0"
        tab_active_bg "#d9cfc0"
        tab_active_fg "#824f16"
        tab_inactive_bg "#e8dfd0"
        tab_inactive_fg "#8a7e72"

        // Pane frames
        pane_frame_bg "#e8dfd0"
        pane_frame_fg "#d9cfc0"

        // Selection
        selection_bg "#824f16"
        selection_fg "#f3eadc"
    }
}
```

- [ ] **Step 4: Create dreamcoder layout**

```kdl
// Dreamcoder Default Layout for Zellij
layout {
    pane borderless=true split_direction="vertical" {
        pane size="20%"
        pane
    }
    pane_session true
}
```

- [ ] **Step 5: Commit**

```bash
git add Zellij/
git commit -m "feat(zellij): add zellij config with dreamcoder dark/light themes"
```

---

### Task 3: Nushell Config + Theme Renderer

**Files:**
- Create: `Nushell/.config/nushell/config.nu`
- Create: `Nushell/.config/nushell/env.nu`
- Create: `Nushell/.config/nushell/dreamcoder-dark.nu`
- Create: `Nushell/.config/nushell/dreamcoder-light.nu`

- [ ] **Step 1: Create env.nu**

```bash
mkdir -p Nushell/.config/nushell
```

```nu
# Nushell environment for Dreamcoder OS
# https://github.com/dreamcoder08/dreamcoder-dots

# Path
$env.PATH = (
    $env.PATH
    | split row (char esep)
    | prepend $"($env.HOME)/.local/bin"
    | prepend $"($env.HOME)/.cargo/bin"
    | prepend $"($env.HOME)/.volta/bin"
    | prepend $"($env.HOME)/.bun/bin"
)

# Editor
$env.EDITOR = "nvim"
$env.VISUAL = "nvim"
$env.COLORTERM = "truecolor"

# Theme mode
$env.DREAMCODER_THEME_MODE = (
    if ($env.DREAMCODER_THEME_MODE? | is-empty) { "dark" }
    else { $env.DREAMCODER_THEME_MODE }
)
```

- [ ] **Step 2: Create config.nu**

```nu
# Nushell configuration for Dreamcoder OS
# https://github.com/dreamcoder08/dreamcoder-dots

# Source theme
source $"($env.HOME)/.config/nushell/dreamcoder-($env.DREAMCODER_THEME_MODE).nu"

# Starship prompt
mkdir ~/.cache/starship
$env.STARSHIP_CACHE = $"($env.HOME)/.cache/starship"

# Aliases
alias g = git
alias gs = "git status"
alias gp = "git push"
alias gl = "git log --oneline --graph"
alias ll = "ls -la"
alias la = "ls -a"
alias cat = "bat"
alias find = "fd"
alias grep = "rg"

# Zoxide
$env.ZOXIDE_QUERY = "zoxide query"
source (zoxide init nushell | save --raw /dev/stdout | null)

# Custom completions
def "nu-complete git branches" [] {
    ^git branch | lines | each { |line| $line | str replace '[\*\+] ' '' | str trim }
}

def "nu-complete git subcommands" [] {
    [add, branch, checkout, cherry-pick, clone, commit, diff, fetch, grep, init, log, merge, pull, push, rebase, reset, rm, show, stash, status, tag]
}
```

- [ ] **Step 3: Create dark theme**

```nu
# Dreamcoder Dark Theme for Nushell
# Auto-generated from tokens.json — do not edit manually

$env.config = {
    color_config: {
        separator: "#6b5f52"
        leading_trailing_space_bg: "#1a1714"
        header: "#d99555"
        date: "#e8dfd0"
        filesize: "#5f95ca"
        row_index: "#6b5f52"
        bool: "#d99555"
        nothing: "#6b5f52"
        binary: "#e8dfd0"
        cellpath: "#e8dfd0"
        int: "#e8dfd0"
        duration: "#e8dfd0"
        range: "#e8dfd0"
        float: "#e8dfd0"
        string: "#e8dfd0"
        record: "#e8dfd0"
        list: "#e8dfd0"
        closure: "#e8dfd0"
        date: "#e8dfd0"
        filesize: "#5f95ca"
        duration: "#e8dfd0"
        range: "#e8dfd0"
        float: "#e8dfd0"
        string: "#e8dfd0"
        nothing: "#6b5f52"
        bool: "#d99555"
        int: "#e8dfd0"
        cellpath: "#e8dfd0"
        row_index: "#6b5f52"
        record: "#e8dfd0"
        list: "#e8dfd0"
        closure: "#e8dfd0"
        custom: "#e8dfd0"
    }
    completions: {
        case_sensitive: false
        quick: true
        partial: true
        algorithm: "fuzzy"
    }
    history: {
        max_size: 50000
        sync_on_enter: true
    }
   .rm: { always_interactive: true }
   .cd: { with_ls: true }
   .ls: { use_ls_colors: true }
}
```

- [ ] **Step 4: Create light theme**

```nu
# Dreamcoder Light Theme for Nushell
# Auto-generated from tokens.json — do not edit manually

$env.config = {
    color_config: {
        separator: "#8a7e72"
        leading_trailing_space_bg: "#e8dfd0"
        header: "#824f16"
        date: "#17120d"
        filesize: "#3a7bc8"
        row_index: "#8a7e72"
        bool: "#824f16"
        nothing: "#8a7e72"
        binary: "#17120d"
        cellpath: "#17120d"
        int: "#17120d"
        duration: "#17120d"
        range: "#17120d"
        float: "#17120d"
        string: "#17120d"
        record: "#17120d"
        list: "#17120d"
        closure: "#17120d"
        date: "#17120d"
        filesize: "#3a7bc8"
        duration: "#17120d"
        range: "#17120d"
        float: "#17120d"
        string: "#17120d"
        nothing: "#8a7e72"
        bool: "#824f16"
        int: "#17120d"
        cellpath: "#17120d"
        row_index: "#8a7e72"
        record: "#17120d"
        list: "#17120d"
        closure: "#17120d"
        custom: "#17120d"
    }
    completions: {
        case_sensitive: false
        quick: true
        partial: true
        algorithm: "fuzzy"
    }
    history: {
        max_size: 50000
        sync_on_enter: true
    }
   .rm: { always_interactive: true }
   .cd: { with_ls: true }
   .ls: { use_ls_colors: true }
}
```

- [ ] **Step 5: Commit**

```bash
git add Nushell/
git commit -m "feat(nushell): add nushell config with dreamcoder dark/light themes"
```

---

### Task 4: WezTerm Config + Theme Renderer

**Files:**
- Create: `WezTerm/.wezterm.lua`
- Create: `WezTerm/.config/wezterm/dreamcoder-dark.lua`
- Create: `WezTerm/.config/wezterm/dreamcoder-light.lua`

- [ ] **Step 1: Create base .wezterm.lua**

```bash
mkdir -p WezTerm/.config/wezterm
```

```lua
-- WezTerm configuration for Dreamcoder OS
-- https://github.com/dreamcoder08/dreamcoder-dots

local wez = require 'wezterm'
local config = wez.config_builder()

-- ─── Theme Detection ──────────────────────────────────
local function get_theme()
    local mode = os.getenv("DREAMCODER_THEME_MODE") or "dark"
    if mode == "light" then
        return wez.plugin.require_file("dreamcoder-light.lua", "dreamcoder-wezterm")
    else
        return wez.plugin.require_file("dreamcoder-dark.lua", "dreamcoder-wezterm")
    end
end

-- ─── Font ─────────────────────────────────────────────
config.font = wez.font('JetBrainsMono Nerd Font')
config.font_size = 14.0
config.line_height = 1.2

-- ─── Window ───────────────────────────────────────────
config.window_background_opacity = 0.76
config.window_decorations = "RESIZE"
config.window_padding = { left = 8, right = 8, top = 8, bottom = 8 }
config.initial_cols = 120
config.initial_rows = 35
config.window_close_confirmation = "NeverPrompt"

-- ─── Cursor ───────────────────────────────────────────
config.default_cursor_style = "BlinkingBlock"
config.cursor_blink_rate = 500
config.cursor_blink_ease_in = "Constant"
config.cursor_blink_ease_out = "Constant"

-- ─── Tab Bar ──────────────────────────────────────────
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true
config.hide_tab_bar_if_only_one_tab = true
config.show_tab_index_in_tab_bar = false

-- ─── Performance ──────────────────────────────────────
config.max_fps = 120
config.animation_fps = 60
config.front_end = "WebGpu"

-- ─── Key Bindings ─────────────────────────────────────
config.keys = {
    { key = "t", mods = "CTRL|SHIFT", action = wez.action.SpawnTab "CurrentPaneDomain" },
    { key = "w", mods = "CTRL|SHIFT", action = wez.action.CloseCurrentTab { confirm = false } },
    { key = "Tab", mods = "CTRL", action = wez.action.ActivateTabRelative(1) },
    { key = "5", mods = "CTRL|SHIFT", action = wez.action.SplitHorizontal { domain = "CurrentPaneDomain" } },
    { key = "6", mods = "CTRL|SHIFT", action = wez.action.SplitVertical { domain = "CurrentPaneDomain" } },
}

-- ─── Shell ────────────────────────────────────────────
config.default_prog = { "fish", "--login" }

return config
```

- [ ] **Step 2: Create dark theme Lua**

```lua
-- Dreamcoder Dark Theme for WezTerm
-- Auto-generated from tokens.json — do not edit manually

local M = {}

M.colors = {
    foreground = "#e8dfd0",
    background = "#100f0d",
    cursor_bg = "#d99555",
    cursor_fg = "#100f0d",
    cursor_border = "#d99555",
    selection_bg = "#d99555",
    selection_fg = "#100f0d",
    ansi = {
        "#100f0d",  -- black
        "#c96a45",  -- red
        "#7a9e6c",  -- green
        "#d99555",  -- yellow
        "#5f95ca",  -- blue
        "#a87cb5",  -- magenta
        "#5f95ca",  -- cyan
        "#e8dfd0",  -- white
    },
    brights = {
        "#6b5f52",  -- black
        "#c96a45",  -- red
        "#7a9e6c",  -- green
        "#d99555",  -- yellow
        "#5f95ca",  -- blue
        "#a87cb5",  -- magenta
        "#5f95ca",  -- cyan
        "#e8dfd0",  -- white
    },
    tab_bar = {
        background = "#1a1714",
        active_tab = {
            bg_color = "#2a2520",
            fg_color = "#d99555",
        },
        inactive_tab = {
            bg_color = "#1a1714",
            fg_color = "#6b5f52",
        },
        inactive_tab_hover = {
            bg_color = "#2a2520",
            fg_color = "#d99555",
        },
    },
}

return M
```

- [ ] **Step 3: Create light theme Lua**

```lua
-- Dreamcoder Light Theme for WezTerm
-- Auto-generated from tokens.json — do not edit manually

local M = {}

M.colors = {
    foreground = "#17120d",
    background = "#f3eadc",
    cursor_bg = "#824f16",
    cursor_fg = "#f3eadc",
    cursor_border = "#824f16",
    selection_bg = "#824f16",
    selection_fg = "#f3eadc",
    ansi = {
        "#17120d",  -- black
        "#b85c2a",  -- red
        "#5a7a4c",  -- green
        "#824f16",  -- yellow
        "#3a7bc8",  -- blue
        "#7a5c85",  -- magenta
        "#3a7bc8",  -- cyan
        "#f3eadc",  -- white
    },
    brights = {
        "#8a7e72",  -- black
        "#b85c2a",  -- red
        "#5a7a4c",  -- green
        "#824f16",  -- yellow
        "#3a7bc8",  -- blue
        "#7a5c85",  -- magenta
        "#3a7bc8",  -- cyan
        "#f3eadc",  -- white
    },
    tab_bar = {
        background = "#e8dfd0",
        active_tab = {
            bg_color = "#d9cfc0",
            fg_color = "#824f16",
        },
        inactive_tab = {
            bg_color = "#e8dfd0",
            fg_color = "#8a7e72",
        },
        inactive_tab_hover = {
            bg_color = "#d9cfc0",
            fg_color = "#824f16",
        },
    },
}

return M
```

- [ ] **Step 4: Commit**

```bash
git add WezTerm/
git commit -m "feat(wezterm): add wezterm config with dreamcoder dark/light themes"
```

---

### Task 5: Alacritty Config + Theme Renderer

**Files:**
- Create: `Alacritty/.config/alacritty/alacritty.toml`
- Create: `Alacritty/.config/alacritty/dreamcoder-dark.toml`
- Create: `Alacritty/.config/alacritty/dreamcoder-light.toml`

- [ ] **Step 1: Create base alacritty.toml**

```bash
mkdir -p Alacritty/.config/alacritty
```

```toml
# Alacritty configuration for Dreamcoder OS
# https://github.com/dreamcoder08/dreamcoder-dots

[env]
TERM = "xterm-256color"

[window]
padding = { x = 8, y = 8 }
decorations = "Full"
opacity = 0.76
blur = true
dynamic_padding = true

[scrolling]
history = 50000

[font]
normal = { family = "JetBrainsMono Nerd Font", style = "Regular" }
bold = { family = "JetBrainsMono Nerd Font", style = "Bold" }
italic = { family = "JetBrainsMono Nerd Font", style = "Italic" }
bold_italic = { family = "JetBrainsMono Nerd Font", style = "Bold Italic" }
size = 14.0

[cursor]
style = { shape = "Block", blinking = "On" }
vi_mode_style = { shape = "Block", blinking = "Off" }

[mouse]
hide_when_typing = true

[selection]
save_to_clipboard = false

# Theme: auto-detect from DREAMCODER_THEME_MODE
[general]
import = ["~/.config/alacritty/dreamcoder-dark.toml"]
```

- [ ] **Step 2: Create dark theme TOML**

```toml
# Dreamcoder Dark Theme for Alacritty
# Auto-generated from tokens.json — do not edit manually

[colors.primary]
background = "#100f0d"
foreground = "#e8dfd0"

[colors.cursor]
text = "#100f0d"
cursor = "#d99555"

[colors.selection]
text = "#100f0d"
background = "#d99555"

[colors.normal]
black = "#100f0d"
red = "#c96a45"
green = "#7a9e6c"
yellow = "#d99555"
blue = "#5f95ca"
magenta = "#a87cb5"
cyan = "#5f95ca"
white = "#e8dfd0"

[colors.bright]
black = "#6b5f52"
red = "#c96a45"
green = "#7a9e6c"
yellow = "#d99555"
blue = "#5f95ca"
magenta = "#a87cb5"
cyan = "#5f95ca"
white = "#e8dfd0"
```

- [ ] **Step 3: Create light theme TOML**

```toml
# Dreamcoder Light Theme for Alacritty
# Auto-generated from tokens.json — do not edit manually

[colors.primary]
background = "#f3eadc"
foreground = "#17120d"

[colors.cursor]
text = "#f3eadc"
cursor = "#824f16"

[colors.selection]
text = "#f3eadc"
background = "#824f16"

[colors.normal]
black = "#17120d"
red = "#b85c2a"
green = "#5a7a4c"
yellow = "#824f16"
blue = "#3a7bc8"
magenta = "#7a5c85"
cyan = "#3a7bc8"
white = "#f3eadc"

[colors.bright]
black = "#8a7e72"
red = "#b85c2a"
green = "#5a7a4c"
yellow = "#824f16"
blue = "#3a7bc8"
magenta = "#7a5c85"
cyan = "#3a7bc8"
white = "#f3eadc"
```

- [ ] **Step 4: Commit**

```bash
git add Alacritty/
git commit -m "feat(alacritty): add alacritty config with dreamcoder dark/light themes"
```

---

## Phase 2: Go Installer (Tasks 6-9)

### Task 6: Go Project Setup

**Files:**
- Create: `installer/go.mod`
- Create: `installer/main.go`
- Create: `installer/Makefile`
- Create: `installer/.gitignore`

- [ ] **Step 1: Initialize Go module**

```bash
mkdir -p installer/cmd installer/internal installer/pkg/version
cd installer
go mod init github.com/dreamcoder08/dreamcoder-dots/installer
```

- [ ] **Step 2: Create main.go**

```go
package main

import (
	"fmt"
	"os"

	"github.com/spf13/cobra"
	"github.com/dreamcoder08/dreamcoder-dots/installer/cmd"
	"github.com/dreamcoder08/dreamcoder-dots/installer/pkg/version"
)

func main() {
	rootCmd := &cobra.Command{
		Use:     "dreamcoder-dots",
		Short:   "Dreamcoder OS - Token-governed visual operating layer",
		Version: version.Version,
		RunE: func(c *cobra.Command, args []string) error {
			// Launch TUI by default
			return cmd.RunTUI()
		},
	}

	rootCmd.AddCommand(cmd.InstallCmd())
	rootCmd.AddCommand(cmd.RepairCmd())
	rootCmd.AddCommand(cmd.DoctorCmd())

	if err := rootCmd.Execute(); err != nil {
		fmt.Fprintln(os.Stderr, err)
		os.Exit(1)
	}
}
```

- [ ] **Step 3: Create version.go**

```go
package version

// Version is injected at build time via ldflags
var Version = "dev"
```

- [ ] **Step 4: Create Makefile**

```makefile
BINARY_NAME := dreamcoder-dots
VERSION := $(shell git describe --tags --always --dirty 2>/dev/null || echo "dev")
LDFLAGS := -ldflags "-X github.com/dreamcoder08/dreamcoder-dots/installer/pkg/version.Version=$(VERSION)"

.PHONY: build build-all release clean

build:
	go build $(LDFLAGS) -o $(BINARY_NAME) .

build-all:
	@echo "Building for linux/amd64..."
	GOOS=linux GOARCH=amd64 go build $(LDFLAGS) -o $(BINARY_NAME)-linux-amd64 .
	@echo "Building for linux/arm64..."
	GOOS=linux GOARCH=arm64 go build $(LDFLAGS) -o $(BINARY_NAME)-linux-arm64 .
	@echo "Building for darwin/amd64..."
	GOOS=darwin GOARCH=amd64 go build $(LDFLAGS) -o $(BINARY_NAME)-darwin-amd64 .
	@echo "Building for darwin/arm64..."
	GOOS=darwin GOARCH=arm64 go build $(LDFLAGS) -o $(BINARY_NAME)-darwin-arm64 .

release: build-all
	gh release create $(VERSION) $(BINARY_NAME)-* --title "v$(VERSION)" --generate-notes

clean:
	rm -f $(BINARY_NAME) $(BINARY_NAME)-*
```

- [ ] **Step 5: Create .gitignore**

```
dreamcoder-dots
dreamcoder-dots-*
*.exe
vendor/
```

- [ ] **Step 6: Verify build**

Run: `cd installer && go build .`
Expected: Binary `dreamcoder-dots` created

- [ ] **Step 7: Commit**

```bash
git add installer/
git commit -m "feat(installer): initialize Go project with Cobra CLI"
```

---

### Task 7: Go TUI Core (Bubbletea)

**Files:**
- Create: `installer/internal/tui/app.go`
- Create: `installer/internal/tui/views/welcome.go`
- Create: `installer/internal/tui/views/components.go`
- Create: `installer/internal/tui/styles/dreamcoder.go`

- [ ] **Step 1: Add Bubbletea dependency**

```bash
cd installer
go get github.com/charmbracelet/bubbletea
go get github.com/charmbracelet/lipgloss
go get github.com/charmbracelet/bubbles
```

- [ ] **Step 2: Create styles/dreamcoder.go**

```go
package styles

import "github.com/charmbracelet/lipgloss"

// Dreamcoder Dark palette
var (
	Primary   = lipgloss.Color("#100f0d")
	Secondary = lipgloss.Color("#1a1714")
	Surface   = lipgloss.Color("#2a2520")
	Text      = lipgloss.Color("#e8dfd0")
	Accent    = lipgloss.Color("#d99555")
	Accent2   = lipgloss.Color("#c96a45")
	Diagnostic = lipgloss.Color("#5f95ca")
	Comment   = lipgloss.Color("#6b5f52")
	Border    = lipgloss.Color("#2a2520")
)

var (
	TitleStyle = lipgloss.NewStyle().
			Bold(true).
			Foreground(Accent).
			Padding(1, 2)

	MenuItemStyle = lipgloss.NewStyle().
			Foreground(Text).
			Padding(0, 2)

	SelectedStyle = lipgloss.NewStyle().
			Foreground(Accent).
			Bold(true).
			Padding(0, 2)

	StatusBarStyle = lipgloss.NewStyle().
			Foreground(Comment).
			Background(Secondary).
			Padding(0, 1)

	BoxStyle = lipgloss.NewStyle().
			Border(lipgloss.RoundedBorder()).
			BorderForeground(Border).
			Padding(1, 2)
)

func Init() {
	// Force dark theme for now
	lipgloss.SetBorderProfile(lipgloss.RoundedBorder())
}
```

- [ ] **Step 3: Create views/welcome.go**

```go
package views

import (
	"fmt"

	tea "github.com/charmbracelet/bubbletea"
	"github.com/charmbracelet/lipgloss"
	"github.com/dreamcoder08/dreamcoder-dots/installer/internal/tui/styles"
)

type WelcomeModel struct {
	width  int
	height int
}

func NewWelcomeModel() WelcomeModel {
	return WelcomeModel{}
}

func (m WelcomeModel) Init() tea.Cmd {
	return nil
}

func (m WelcomeModel) Update(msg tea.Msg) (tea.Model, tea.Cmd) {
	switch msg := msg.(type) {
	case tea.WindowSizeMsg:
		m.width = msg.Width
		m.height = msg.Height
	case tea.KeyMsg:
		switch msg.String() {
		case "enter":
			return NewComponentsModel(), nil
		case "q", "ctrl+c":
			return m, tea.Quit
		}
	}
	return m, nil
}

func (m WelcomeModel) View() string {
	logo := `
   ╔═══════════════════════════════════════╗
   ║                                       ║
   ║   🎨 DREAMCODER OS                    ║
   ║                                       ║
   ║   Token-governed visual operating     ║
   ║   layer for the discerning developer  ║
   ║                                       ║
   ╚═══════════════════════════════════════╝
`
	platform := fmt.Sprintf("Platform: %s/%s", detectOS(), detectArch())
	hint := "Press Enter to continue, q to quit"

	return lipgloss.Place(
		m.width, m.height,
		lipgloss.Center, lipgloss.Center,
		lipgloss.JoinVertical(
			lipgloss.Center,
			styles.TitleStyle.Render(logo),
			styles.MenuItemStyle.Render(platform),
			"",
			styles.CommentStyle.Render(hint),
		),
	)
}

func detectOS() string {
	// TODO: implement runtime.GOOS
	return "linux"
}

func detectArch() string {
	// TODO: implement runtime.GOARCH
	return "amd64"
}
```

- [ ] **Step 4: Create views/components.go**

```go
package views

import (
	"fmt"

	tea "github.com/charmbracelet/bubbletea"
	"github.com/charmbracelet/lipgloss"
	"github.com/dreamcoder08/dreamcoder-dots/installer/internal/tui/styles"
)

type Component struct {
	Name        string
	Description string
	Selected    bool
	Category    string
}

type ComponentsModel struct {
	components []Component
	cursor    int
	width     int
	height    int
}

func NewComponentsModel() ComponentsModel {
	components := []Component{
		{Name: "Kitty", Description: "GPU-accelerated terminal", Category: "Terminals", Selected: true},
		{Name: "Ghostty", Description: "Fast, feature-rich terminal", Category: "Terminals", Selected: false},
		{Name: "WezTerm", Description: "Cross-platform terminal", Category: "Terminals", Selected: false},
		{Name: "Alacritty", Description: "Minimal GPU terminal", Category: "Terminals", Selected: false},
		{Name: "Fish", Description: "Friendly interactive shell", Category: "Shells", Selected: true},
		{Name: "Zsh", Description: "Z shell", Category: "Shells", Selected: false},
		{Name: "Nushell", Description: "Modern structured shell", Category: "Shells", Selected: false},
		{Name: "Tmux", Description: "Terminal multiplexer", Category: "Multiplexers", Selected: false},
		{Name: "Zellij", Description: "Terminal workspace", Category: "Multiplexers", Selected: false},
		{Name: "Neovim", Description: "Hyperextensible editor", Category: "Editor", Selected: true},
	}

	return ComponentsModel{components: components}
}

func (m ComponentsModel) Init() tea.Cmd {
	return nil
}

func (m ComponentsModel) Update(msg tea.Msg) (tea.Model, tea.Cmd) {
	switch msg := msg.(type) {
	case tea.WindowSizeMsg:
		m.width = msg.Width
		m.height = msg.Height
	case tea.KeyMsg:
		switch msg.String() {
		case "up", "k":
			if m.cursor > 0 {
				m.cursor--
			}
		case "down", "j":
			if m.cursor < len(m.components)-1 {
				m.cursor++
			}
		case " ":
			m.components[m.cursor].Selected = !m.components[m.cursor].Selected
		case "enter":
			// Go to theme preview
			return NewThemePreviewModel(), nil
		case "q", "ctrl+c":
			return m, tea.Quit
		case "esc":
			return NewWelcomeModel(), nil
		}
	}
	return m, nil
}

func (m ComponentsModel) View() string {
	title := styles.TitleStyle.Render("📦 Select Components")

	var items []string
	for i, comp := range m.components {
		checkbox := "[ ]"
		if comp.Selected {
			checkbox = "[✓]"
		}

		style := styles.MenuItemStyle
		if i == m.cursor {
			style = styles.SelectedStyle
		}

		item := fmt.Sprintf("%s %s — %s", checkbox, comp.Name, comp.Description)
		items = append(items, style.Render(item))
	}

	list := lipgloss.JoinVertical(lipgloss.Left, items...)
	hint := styles.CommentStyle.Render("Space to select, Enter to continue, Esc to go back")

	return lipgloss.Place(
		m.width, m.height,
		lipgloss.Center, lipgloss.Center,
		lipgloss.JoinVertical(lipgloss.Center, title, "", list, "", hint),
	)
}
```

- [ ] **Step 5: Create app.go**

```go
package tui

import (
	tea "github.com/charmbracelet/bubbletea"
	"github.com/dreamcoder08/dreamcoder-dots/installer/internal/tui/views"
	"github.com/dreamcoder08/dreamcoder-dots/installer/internal/tui/styles"
)

func RunTUI() error {
	styles.Init()
	p := tea.NewProgram(views.NewWelcomeModel(), tea.WithAltScreen())
	_, err := p.Run()
	return err
}
```

- [ ] **Step 6: Update cmd/tui.go**

```go
package cmd

import (
	tea "github.com/charmbracelet/bubbletea"
	"github.com/dreamcoder08/dreamcoder-dots/installer/internal/tui"
)

func RunTUI() error {
	return tui.RunTUI()
}
```

- [ ] **Step 7: Verify TUI builds**

Run: `cd installer && go build . && ./dreamcoder-dots`
Expected: TUI launches with welcome screen

- [ ] **Step 8: Commit**

```bash
git add installer/
git commit -m "feat(installer): add TUI with welcome and component selector screens"
```

---

### Task 8: Install Logic + Platform Detection

**Files:**
- Create: `installer/internal/installer/installer.go`
- Create: `installer/internal/installer/platforms.go`
- Create: `installer/internal/installer/stow.go`
- Create: `installer/cmd/install.go`
- Create: `installer/cmd/repair.go`
- Create: `installer/cmd/doctor.go`

- [ ] **Step 1: Create platforms.go**

```go
package installer

import (
	"os"
	"os/exec"
	"runtime"
)

type Platform struct {
	OS      string
	Arch    string
	Distro  string
	HasStow bool
	HasGit  bool
}

func DetectPlatform() Platform {
	p := Platform{
		OS:      runtime.GOOS,
		Arch:    runtime.GOARCH,
		Distro:  detectDistro(),
		HasStow: commandExists("stow"),
		HasGit:  commandExists("git"),
	}
	return p
}

func detectDistro() string {
	if _, err := os.ReadFile("/etc/os-release"); err == nil {
		// Parse os-release
		data, _ := os.ReadFile("/etc/os-release")
		content := string(data)
		if contains(content, "Arch") || contains(content, "arch") {
			return "arch"
		}
		if contains(content, "Fedora") || contains(content, "fedora") {
			return "fedora"
		}
		if contains(content, "Ubuntu") || contains(content, "ubuntu") || contains(content, "Debian") {
			return "debian"
		}
	}
	// macOS
	if runtime.GOOS == "darwin" {
		return "macos"
	}
	return "unknown"
}

func commandExists(cmd string) bool {
	_, err := exec.LookPath(cmd)
	return err == nil
}

func contains(s, substr string) bool {
	return len(s) >= len(substr) && (s == substr || len(s) > 0 && containsHelper(s, substr))
}

func containsHelper(s, substr string) bool {
	for i := 0; i <= len(s)-len(substr); i++ {
		if s[i:i+len(substr)] == substr {
			return true
		}
	}
	return false
}
```

- [ ] **Step 2: Create installer.go**

```go
package installer

import (
	"fmt"
	"os"
	"os/exec"
	"path/filepath"
)

type Installer struct {
	Platform   Platform
	Components []string
	ThemeMode  string
	DotfilesDir string
}

func NewInstaller(platform Platform, components []string, themeMode string) *Installer {
	home, _ := os.UserHomeDir()
	return &Installer{
		Platform:    platform,
		Components:  components,
		ThemeMode:   themeMode,
		DotfilesDir: filepath.Join(home, "Documents", "PROYECTOS", "dreamcoder-dots"),
	}
}

func (i *Installer) Install(progressFunc func(component string, status string)) error {
	for _, comp := range i.Components {
		progressFunc(comp, "installing")
		
		if err := i.installComponent(comp); err != nil {
			progressFunc(comp, "error: "+err.Error())
			return fmt.Errorf("failed to install %s: %w", comp, err)
		}
		
		progressFunc(comp, "done")
	}
	return nil
}

func (i *Installer) installComponent(component string) error {
	switch component {
	case "kitty":
		return i.stow("Kitty")
	case "ghostty":
		return i.stow("Ghostty")
	case "wezterm":
		return i.stow("WezTerm")
	case "alacritty":
		return i.stow("Alacritty")
	case "fish":
		return i.stow("Shell")
	case "zsh":
		return i.stow("Shell")
	case "nushell":
		return i.stow("Nushell")
	case "tmux":
		return i.stow("Tmux")
	case "zellij":
		return i.stow("Zellij")
	case "nvim":
		return i.stow("Nvim")
	default:
		return fmt.Errorf("unknown component: %s", component)
	}
}

func (i *Installer) stow(module string) error {
	cmd := exec.Command("stow", "-d", i.DotfilesDir, "-t", os.Getenv("HOME"), module)
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr
	return cmd.Run()
}
```

- [ ] **Step 3: Create stow.go (backup/restore)**

```go
package installer

import (
	"encoding/json"
	"os"
	"path/filepath"
	"time"
)

type BackupEntry struct {
	Source      string    `json:"source"`
	Destination string    `json:"destination"`
	Timestamp   time.Time `json:"timestamp"`
}

type BackupManifest struct {
	Entries []BackupEntry `json:"entries"`
}

func BackupFile(source, dest string) error {
	home, _ := os.UserHomeDir()
	manifestPath := filepath.Join(home, ".config", "dreamcoder", "backup-manifest.json")
	
	// Read existing manifest
	var manifest BackupManifest
	if data, err := os.ReadFile(manifestPath); err == nil {
		json.Unmarshal(data, &manifest)
	}
	
	// Add new entry
	manifest.Entries = append(manifest.Entries, BackupEntry{
		Source:      source,
		Destination: dest,
		Timestamp:   time.Now(),
	})
	
	// Write manifest
	data, _ := json.MarshalIndent(manifest, "", "  ")
	return os.WriteFile(manifestPath, data, 0644)
}
```

- [ ] **Step 4: Create cmd/install.go**

```go
package cmd

import (
	"fmt"
	"os"

	"github.com/spf13/cobra"
	"github.com/dreamcoder08/dreamcoder-dots/installer/internal/installer"
)

var (
	components []string
	themeMode  string
)

var installCmd = &cobra.Command{
	Use:   "install",
	Short: "Install Dreamcoder OS components",
	RunE: func(cmd *cobra.Command, args []string) error {
		platform := installer.DetectPlatform()
		fmt.Printf("Detected platform: %s/%s (%s)\n", platform.OS, platform.Arch, platform.Distro)
		
		if !platform.HasStow {
			return fmt.Errorf("GNU Stow is required. Install it first.")
		}
		
		inst := installer.NewInstaller(platform, components, themeMode)
		
		return inst.Install(func(component, status string) {
			fmt.Printf("[%s] %s\n", component, status)
		})
	},
}

func init() {
	installCmd.Flags().StringSliceVarP(&components, "components", "c", 
		[]string{"kitty", "fish", "nvim"}, "Components to install")
	installCmd.Flags().StringVarP(&themeMode, "theme", "t", "dark", "Theme mode (dark/light/dusk)")
	rootCmd.AddCommand(installCmd)
}
```

- [ ] **Step 5: Create cmd/repair.go**

```go
package cmd

import (
	"fmt"
	"os/exec"

	"github.com/spf13/cobra"
)

var repairCmd = &cobra.Command{
	Use:   "repair",
	Short: "Reapply hooks after upstream updates",
	RunE: func(cmd *cobra.Command, args []string) error {
		fmt.Println("Reapplying Dreamcoder hooks...")
		
		// Re-stow all modules
		modules := []string{"Kitty", "Ghostty", "Shell", "Nvim", "Fastfetch", "Tmux", "Zellij", "Nushell"}
		for _, mod := range modules {
			fmt.Printf("Restowing %s...\n", mod)
			exec.Command("stow", "-D", "-t", "$HOME", mod).Run()
			exec.Command("stow", "-t", "$HOME", mod).Run()
		}
		
		fmt.Println("Repair complete!")
		return nil
	},
}

func init() {
	rootCmd.AddCommand(repairCmd)
}
```

- [ ] **Step 6: Create cmd/doctor.go**

```bash
go get github.com/fatih/color
```

```go
package cmd

import (
	"fmt"
	"os"
	"os/exec"
	"runtime"

	"github.com/fatih/color"
	"github.com/spf13/cobra"
)

var doctorCmd = &cobra.Command{
	Use:   "doctor",
	Short: "Check health of Dreamcoder OS installation",
	RunE: func(cmd *cobra.Command, args []string) error {
		green := color.New(color.FgGreen).SprintFunc()
		red := color.New(color.FgRed).SprintFunc()
		yellow := color.New(color.FgYellow).SprintFunc()
		
		fmt.Println("🔍 Dreamcoder OS Doctor")
		fmt.Println("========================")
		
		// Check platform
		fmt.Printf("Platform: %s/%s\n", runtime.GOOS, runtime.GOARCH)
		
		// Check tools
		tools := map[string]string{
			"git":      "Version control",
			"stow":     "Symlink manager",
			"nvim":     "Editor",
			"fish":     "Shell",
			"kitty":    "Terminal",
			"ghostty":  "Terminal",
			"starship": "Prompt",
			"fzf":      "Fuzzy finder",
			"zoxide":   "Smart cd",
		}
		
		for tool, desc := range tools {
			if _, err := exec.LookPath(tool); err == nil {
				fmt.Printf("  %s %s (%s)\n", green("✓"), tool, desc)
			} else {
				fmt.Printf("  %s %s (%s) — not found\n", red("✗"), tool, desc)
			}
		}
		
		// Check theme mode
		mode := os.Getenv("DREAMCODER_THEME_MODE")
		if mode == "" {
			mode = "dark"
		}
		fmt.Printf("\nTheme Mode: %s\n", yellow(mode))
		
		// Check dotfiles dir
		home, _ := os.UserHomeDir()
		dotfiles := home + "/Documents/PROYECTOS/dreamcoder-dots"
		if _, err := os.Stat(dotfiles); err == nil {
			fmt.Printf("Dotfiles: %s %s\n", green("✓"), dotfiles)
		} else {
			fmt.Printf("Dotfiles: %s %s\n", red("✗"), dotfiles)
		}
		
		return nil
	},
}

func init() {
	rootCmd.AddCommand(doctorCmd)
}
```

- [ ] **Step 7: Verify all commands work**

Run: `cd installer && go build . && ./dreamcoder-dots doctor`
Expected: Doctor output with tool checks

Run: `./dreamcoder-dots install --help`
Expected: Install help with component flags

- [ ] **Step 8: Commit**

```bash
git add installer/
git commit -m "feat(installer): add install, repair, and doctor commands"
```

---

### Task 9: Homebrew Tap

**Files:**
- Create: `homebrew-tap/Formula/dreamcoder-dots.rb`

- [ ] **Step 1: Create formula directory**

```bash
mkdir -p homebrew-tap/Formula
```

- [ ] **Step 2: Create Homebrew formula**

```ruby
class DreamcoderDots < Formula
  desc "Dreamcoder OS - Token-governed visual operating layer"
  homepage "https://github.com/dreamcoder08/dreamcoder-dots"
  version "2.0.0"
  license "MIT"

  on_macos do
    on_arm64 do
      url "https://github.com/dreamcoder08/dreamcoder-dots/releases/download/v2.0.0/dreamcoder-dots-darwin-arm64"
      sha256 "PLACEHOLDER_SHA256_DARWIN_ARM64"
    end
    on_intel do
      url "https://github.com/dreamcoder08/dreamcoder-dots/releases/download/v2.0.0/dreamcoder-dots-darwin-amd64"
      sha256 "PLACEHOLDER_SHA256_DARWIN_AMD64"
    end
  end

  on_linux do
    on_arm64 do
      url "https://github.com/dreamcoder08/dreamcoder-dots/releases/download/v2.0.0/dreamcoder-dots-linux-arm64"
      sha256 "PLACEHOLDER_SHA256_LINUX_ARM64"
    end
    on_intel do
      url "https://github.com/dreamcoder08/dreamcoder-dots/releases/download/v2.0.0/dreamcoder-dots-linux-amd64"
      sha256 "PLACEHOLDER_SHA256_LINUX_AMD64"
    end
  end

  def install
    bin.install "dreamcoder-dots"
  end

  test do
    assert_match "dreamcoder-dots", shell_output("#{bin}/dreamcoder-dots --version")
  end
end
```

- [ ] **Step 3: Commit**

```bash
git add homebrew-tap/
git commit -m "feat(homebrew): add Homebrew tap formula for multi-platform install"
```

---

## Phase 3: Vim Trainer (Task 10)

### Task 10: Vim Mastery Trainer (Module 1)

**Files:**
- Create: `installer/internal/tui/views/vim-trainer.go`
- Create: `installer/internal/tui/views/vim-editor.go`
- Create: `installer/internal/tui/trainer/module.go`
- Create: `installer/internal/tui/trainer/player.go`
- Create: `installer/internal/tui/trainer/persistence.go`

- [ ] **Step 1: Create trainer/module.go**

```go
package trainer

type Module struct {
	ID          int
	Name        string
	Keys        []string
	Lessons     []Lesson
	BossFight   BossFight
}

type Lesson struct {
	ID       int
	Name     string
	Task     string
	Expected string
	Hint     string
}

type BossFight struct {
	Name  string
	Tasks []Lesson
}

type Module1 struct{}

func (m Module1) GetModule() Module {
	return Module{
		ID:   1,
		Name: "Horizontal Movement",
		Keys: []string{"w", "e", "b", "f", "t", "0", "$", "^"},
		Lessons: []Lesson{
			{ID: 1, Name: "Word Forward", Task: "Move to next word", Expected: "w", Hint: "Press w to jump to next word start"},
			{ID: 2, Name: "Word End", Task: "Move to end of word", Expected: "e", Hint: "Press e to jump to word end"},
			{ID: 3, Name: "Word Back", Task: "Move to previous word", Expected: "b", Hint: "Press b to jump back"},
			// ... 12 more lessons
		},
		BossFight: BossFight{
			Name: "Code Maze",
			Tasks: []Lesson{
				{ID: 100, Name: "Navigate to function", Task: "Use w, e, b to reach the function name", Expected: "web"},
				{ID: 101, Name: "Find character", Task: "Use f to jump to specific char", Expected: "f("},
				{ID: 102, Name: "Line start/end", Task: "Use 0 and $ to navigate line", Expected: "0$"},
			},
		},
	}
}
```

- [ ] **Step 2: Create trainer/player.go**

```go
package trainer

type Player struct {
	XP          int            `json:"xp"`
	Level       int            `json:"level"`
	Title       string         `json:"title"`
	Achievements []string      `json:"achievements"`
	Modules     map[int]ModuleProgress `json:"modules"`
}

type ModuleProgress struct {
	CompletedLessons []int          `json:"completed"`
	BestScores       map[int]int    `json:"best_scores"`
	BossDefeated     bool           `json:"boss_defeated"`
}

func NewPlayer() *Player {
	return &Player{
		XP:      0,
		Level:   1,
		Title:   "Vim Beginner",
		Modules: make(map[int]ModuleProgress),
	}
}

func (p *Player) AddXP(amount int) {
	p.XP += amount
	p.updateLevel()
}

func (p *Player) updateLevel() {
	switch {
	case p.XP >= 2500:
		p.Level = 7
		p.Title = "Vim Sage"
	case p.XP >= 1500:
		p.Level = 6
		p.Title = "Vim Wizard"
	case p.XP >= 1000:
		p.Level = 5
		p.Title = "Vim Master"
	case p.XP >= 600:
		p.Level = 4
		p.Title = "Vim Expert"
	case p.XP >= 300:
		p.Level = 3
		p.Title = "Vim Journeyman"
	case p.XP >= 100:
		p.Level = 2
		p.Title = "Vim Apprentice"
	default:
		p.Level = 1
		p.Title = "Vim Beginner"
	}
}

func (p *Player) CompleteLesson(moduleID, lessonID int, score int, hintsUsed bool) {
	if _, ok := p.Modules[moduleID]; !ok {
		p.Modules[moduleID] = ModuleProgress{
			CompletedLessons: []int{},
			BestScores:       make(map[int]int),
		}
	}
	
	mod := p.Modules[moduleID]
	mod.CompletedLessons = append(mod.CompletedLessons, lessonID)
	
	if score > mod.BestScores[lessonID] {
		mod.BestScores[lessonID] = score
	}
	
	p.Modules[moduleID] = mod
	
	// XP rewards
	xp := 10
	if score == 100 && !hintsUsed {
		xp += 25 // Perfect bonus
	}
	p.AddXP(xp)
}
```

- [ ] **Step 3: Create trainer/persistence.go**

```go
package trainer

import (
	"encoding/json"
	"os"
	"path/filepath"
)

func GetSavePath() string {
	home, _ := os.UserHomeDir()
	return filepath.Join(home, ".config", "dreamcoder", "vim-trainer.json")
}

func SavePlayer(player *Player) error {
	path := GetSavePath()
	os.MkdirAll(filepath.Dir(path), 0755)
	
	data, err := json.MarshalIndent(player, "", "  ")
	if err != nil {
		return err
	}
	
	return os.WriteFile(path, data, 0644)
}

func LoadPlayer() (*Player, error) {
	path := GetSavePath()
	
	data, err := os.ReadFile(path)
	if err != nil {
		return NewPlayer(), nil // Return fresh player if no save
	}
	
	var player Player
	if err := json.Unmarshal(data, &player); err != nil {
		return NewPlayer(), nil
	}
	
	return &player, nil
}
```

- [ ] **Step 4: Create views/vim-trainer.go**

```go
package views

import (
	"fmt"

	tea "github.com/charmbracelet/bubbletea"
	"github.com/charmbracelet/lipgloss"
	"github.com/dreamcoder08/dreamcoder-dots/installer/internal/tui/styles"
	"github.com/dreamcoder08/dreamcoder-dots/installer/internal/tui/trainer"
)

type VimTrainerModel struct {
	player   *trainer.Player
	module   int
	lesson   int
	width    int
	height   int
}

func NewVimTrainerModel() VimTrainerModel {
	player, _ := trainer.LoadPlayer()
	return VimTrainerModel{player: player}
}

func (m VimTrainerModel) Init() tea.Cmd {
	return nil
}

func (m VimTrainerModel) Update(msg tea.Msg) (tea.Model, tea.Cmd) {
	switch msg := msg.(type) {
	case tea.WindowSizeMsg:
		m.width = msg.Width
		m.height = msg.Height
	case tea.KeyMsg:
		switch msg.String() {
		case "q", "ctrl+c":
			trainer.SavePlayer(m.player)
			return NewComponentsModel(), nil
		}
	}
	return m, nil
}

func (m VimTrainerModel) View() string {
	title := styles.TitleStyle.Render("🎮 VIM MASTERY TRAINER")
	
	// Player stats
	stats := fmt.Sprintf("⭐ Lv%d %d XP — %s", m.player.Level, m.player.XP, m.player.Title)
	
	// Module list
	modules := []string{
		"✅ 1. Horizontal Movement",
		"✅ 2. Vertical Movement",
		"🔓 3. Text Objects",
		"🔒 4. Change & Repeat",
		"🔒 5. Substitution",
		"🔒 6. Macros & Registers",
		"🔒 7. Regex Search",
	}
	
	moduleList := lipgloss.JoinVertical(lipgloss.Left, modules...)
	
	// Editor placeholder
	editor := styles.BoxStyle.Width(50).Height(10).Render("Practice here...")
	
	leftPanel := lipgloss.JoinVertical(lipgloss.Left, 
		styles.MenuItemStyle.Render(stats),
		"",
		moduleList,
	)
	
	rightPanel := editor
	
	content := lipgloss.JoinHorizontal(lipgloss.Top, leftPanel, "  ", rightPanel)
	
	return lipgloss.Place(
		m.width, m.height,
		lipgloss.Center, lipgloss.Center,
		lipgloss.JoinVertical(lipgloss.Center, title, "", content),
	)
}
```

- [ ] **Step 5: Wire up in app.go**

Update `installer/internal/tui/app.go` to add VimTrainer route:

```go
// In views/components.go, add case for "v":
case "v":
    return NewVimTrainerModel(), nil
```

- [ ] **Step 6: Verify trainer builds**

Run: `cd installer && go build .`
Expected: No errors

- [ ] **Step 7: Commit**

```bash
git add installer/
git commit -m "feat(trainer): add Vim Mastery Trainer with Module 1 and XP system"
```

---

## Phase 4: Documentation (Task 11)

### Task 11: Documentation Suite

**Files:**
- Create: `docs/README.md`
- Create: `docs/installation/linux.md`
- Create: `docs/installation/macos.md`
- Create: `docs/installation/wsl.md`
- Create: `docs/installation/termux.md`
- Create: `docs/configuration/theme-system.md`
- Create: `docs/configuration/shell-config.md`
- Create: `docs/configuration/terminal-config.md`
- Create: `docs/configuration/multiplexer-config.md`
- Create: `docs/configuration/editor-config.md`
- Create: `docs/migration/from-ml4w.md`
- Create: `docs/migration/from-gentleman.md`
- Modify: `README.md` (update with new features)

- [ ] **Step 1: Create docs/README.md**

```markdown
# Dreamcoder OS Documentation

Welcome to the Dreamcoder OS documentation.

## Quick Links

- [Installation](installation/linux.md)
- [Theme System](configuration/theme-system.md)
- [Migration from ML4W](migration/from-ml4w.md)
- [Migration from Gentleman](migration/from-gentleman.md)

## Getting Started

### Install via Homebrew (Recommended)

```bash
brew install dreamcoder08/tap/dreamcoder-dots
dreamcoder-dots
```

### Install via Curl

```bash
curl -fsSL https://raw.githubusercontent.com/dreamcoder08/dreamcoder-dots/main/install.sh | bash
```

## What's Included

| Component | Status |
|-----------|--------|
| Kitty | ✅ |
| Ghostty | ✅ |
| WezTerm | ✅ |
| Alacritty | ✅ |
| Fish | ✅ |
| Zsh | ✅ |
| Nushell | ✅ |
| Tmux | ✅ |
| Zellij | ✅ |
| Neovim (LazyVim) | ✅ |
| Vim Trainer | ✅ |
```

- [ ] **Step 2: Create Linux installation guide**

```markdown
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
```

- [ ] **Step 3: Create macOS installation guide**

```markdown
# Installing Dreamcoder OS on macOS

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
```

- [ ] **Step 4: Create WSL installation guide**

```markdown
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
```

- [ ] **Step 5: Create Termux installation guide**

```markdown
# Installing Dreamcoder OS on Termux (Android)

## Prerequisites

- Termux app (from F-Droid, NOT Play Store)
- Android 7+

## Install

```bash
pkg update && pkg upgrade
pkg install stow git python nodejs

git clone https://github.com/dreamcoder08/dreamcoder-dots.git ~/dreamcoder-dots
cd ~/dreamcoder-dots
./scripts/dreamcoder install
```

## Limitations

- No systemd (day/night automation unavailable)
- No GUI apps (Kitty/Ghostty unavailable)
- Limited shader support
```

- [ ] **Step 6: Create theme system docs**

```markdown
# Dreamcoder Theme System

## Architecture

```
tokens.json → Theme Engine (Python) → 48 config files → 22 targets
```

## Token Schema

All colors are defined in `themes/dreamcoder/tokens.json`:

```json
{
  "dark": {
    "background": "#100f0d",
    "text": "#e8dfd0",
    "accent": "#d99555",
    "accent_2": "#c96a45",
    "diagnostic": "#5f95ca"
  },
  "light": {
    "background": "#f3eadc",
    "text": "#17120d",
    "accent": "#824f16",
    "accent_2": "#b85c2a",
    "diagnostic": "#3a7bc8"
  }
}
```

## Regenerating Themes

After editing `tokens.json`:

```bash
./scripts/dreamcoder sync
```

## Adding New Targets

1. Create renderer in `scripts/dreamcoder_theme/renderers_<target>.py`
2. Add token mapping
3. Run `./scripts/dreamcoder sync`
4. Files appear in `themes/dreamcoder/`
```

- [ ] **Step 7: Create migration guides**

```markdown
# Migrating from ML4W

## What Changes

- Theme system: Material You → Token-based (Dreamcoder)
- Installer: QML app → Go binary TUI
- Config location: `~/.config/ml4w/` → `~/.config/dreamcoder/`

## Migration Steps

1. Backup ML4W config: `cp -r ~/.config/ml4w ~/.config/ml4w-backup`
2. Install Dreamcoder: `brew install dreamcoder08/tap/dreamcoder-dots`
3. Run installer: `dreamcoder-dots`
4. Select components to migrate
5. Remove ML4W when satisfied: `rm -rf ~/.config/ml4w`
```

```markdown
# Migrating from Gentleman.Dots

## What Changes

- AI layer: Separate (gentle-ai) → Separate (dreamcoder-ai)
- Installer: Go binary → Go binary (different TUI)
- Shell: Same (Fish/Zsh) + Nushell added

## Migration Steps

1. Backup Gentleman config: `cp -r ~/.config/gentleman ~/.config/gentleman-backup`
2. Install Dreamcoder: `brew install dreamcoder08/tap/dreamcoder-dots`
3. Run installer: `dreamcoder-dots`
4. For AI layer: `brew install dreamcoder08/tap/dreamcoder-ai`
5. Remove Gentleman when satisfied
```

- [ ] **Step 8: Update root README.md**

Update the main README with:
- New badges (version, platforms, health)
- Updated feature table
- Installation commands for all platforms
- TUI screenshot placeholder

- [ ] **Step 9: Commit**

```bash
git add docs/ README.md
git commit -m "docs: add comprehensive documentation suite with migration guides"
```

---

## Summary

| Task | Deliverable | Files Created |
|------|-------------|---------------|
| 1 | Tmux config | 3 files |
| 2 | Zellij config | 4 files |
| 3 | Nushell config | 4 files |
| 4 | WezTerm config | 3 files |
| 5 | Alacritty config | 3 files |
| 6 | Go project setup | 4 files |
| 7 | TUI core | 5 files |
| 8 | Install logic | 6 files |
| 9 | Homebrew tap | 1 file |
| 10 | Vim Trainer | 5 files |
| 11 | Documentation | 15+ files |

**Total:** ~53 new files, 2 modified files

**Estimated effort:** 2-3 focused coding sessions

**Success criteria:**
- ✅ All terminal configs work with `dreamcoder sync`
- ✅ Go binary compiles for 4 platforms
- ✅ Homebrew install works
- ✅ TUI navigates all screens
- ✅ Vim Trainer Module 1 playable
- ✅ Docs cover all platforms
- ✅ No regressions in existing tests
