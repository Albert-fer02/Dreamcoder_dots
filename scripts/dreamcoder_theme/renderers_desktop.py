"""Desktop shell and editor theme renderers."""

from __future__ import annotations

import json

def hypr_content(c: dict[str, str]) -> str:
    return f"""# Dreamcoder color layer for Hyprland.
# Import after ML4W/Gentleman defaults; this changes colors only.

general {{
    col.active_border = rgba({c['accent'][1:]}ff) rgba({c['diagnostic'][1:]}ff) 45deg
    col.inactive_border = {c['inactive_border']}
}}

misc {{
    background_color = rgba({c['bg'][1:]}ff)
}}
"""

def waybar_content(c: dict[str, str]) -> str:
    return f"""/* Dreamcoder color layer for Waybar. */
@define-color bg {c['bg']};
@define-color bg-soft {c['bg_soft']};
@define-color surface {c['surface0']};
@define-color text {c['text']};
@define-color muted {c['muted']};
@define-color border {c['border']};
@define-color border-ui {c['border_ui']};
@define-color focus {c['focus']};
@define-color accent {c['accent']};
@define-color accent-2 {c['accent_2']};
@define-color diagnostic {c['diagnostic']};
@define-color error {c['error']};
@define-color success {c['sage']};
@define-color warning {c['warning']};

window#waybar {{
  background: {c['panel_rgba']};
  color: @text;
  border-bottom: 1px solid alpha(@accent, 0.26);
}}

#workspaces button {{
  color: @muted;
  background: transparent;
  border: 1px solid transparent;
}}

#workspaces button.active {{
  color: @accent;
  background: {c['active_rgba']};
  border-color: alpha(@focus, 0.82);
}}

#clock,
#battery,
#network,
#pulseaudio,
#cpu,
#memory,
#tray {{
  background: {c['module_rgba']};
  color: @text;
  border: 1px solid alpha(@border-ui, 0.78);
}}

#battery.warning {{ color: @warning; }}
#battery.critical {{ color: @error; }}
#network.disconnected {{ color: @error; }}
"""

def rofi_content(c: dict[str, str]) -> str:
    return f"""/* Dreamcoder color layer for Rofi. */
* {{
  background: {c['panel_rgba']};
  background-alt: {c['surface0']};
  foreground: {c['text']};
  muted: {c['muted']};
  selected: {c['active_rgba']};
  active: {c['accent']};
  border-ui: {c['border_ui']};
  focus: {c['focus']};
  urgent: {c['error']};
  border-color: {c['border_ui']};
}}

window {{
  background-color: @background;
  border: 1px;
  border-color: @border-ui;
  border-radius: 18px;
}}

entry {{
  background-color: @selected;
  text-color: @foreground;
  border: 1px;
  border-color: @focus;
  border-radius: 12px;
}}

element selected {{
  background-color: @selected;
  text-color: @foreground;
  border: 0 0 0 3px;
  border-color: @focus;
}}

element-text {{ text-color: @muted; }}
element selected element-text {{ text-color: @foreground; }}
"""

def antigravity_content(c: dict[str, str]) -> str:
    theme_type = "dark" if "Dark" in c.get("name", "Dark") else "light"
    return json.dumps({
        "name": c.get("name", "Dreamcoder"),
        "type": theme_type,
        "colors": {
            "editor.background": c["bg"],
            "editor.foreground": c["text"],
            "activityBar.background": c["surface0"],
            "activityBar.foreground": c["accent"],
            "activityBar.inactiveForeground": c["comment"],
            "activityBar.border": c["border_ui"],
            "sideBar.background": c["surface0"],
            "sideBar.foreground": c["text"],
            "sideBar.border": c["border_ui"],
            "statusBar.background": c["bg"],
            "statusBar.foreground": c["text"],
            "statusBar.border": c["border_ui"],
            "editorGroupHeader.tabsBackground": c["surface0"],
            "tab.activeBackground": c["bg"],
            "tab.activeForeground": c["accent"],
            "tab.inactiveBackground": c["surface0"],
            "tab.inactiveForeground": c["comment"],
            "tab.border": c["border_ui"],
            "editor.lineHighlightBackground": c["surface0"],
            "editorLineNumber.foreground": c["comment"],
            "editorLineNumber.activeForeground": c["accent"],
            "editorWidget.background": c["surface1"],
            "editorWidget.border": c["border_ui"],
            "input.background": c["surface1"],
            "input.foreground": c["text"],
            "input.border": c["focus"],
            "button.background": c["accent_2"],
            "button.foreground": c["text"],
            "list.activeSelectionBackground": c["selection"],
            "list.activeSelectionForeground": c["text"],
            "list.hoverBackground": c["surface0"],
            "editor.selectionBackground": c["selection"],
            "terminal.background": c["bg"],
            "terminal.foreground": c["text"],
            "terminal.ansiBlack": c["surface0"],
            "terminal.ansiRed": c["error"],
            "terminal.ansiGreen": c["sage"],
            "terminal.ansiYellow": c["warning"],
            "terminal.ansiBlue": c["accent"],
            "terminal.ansiMagenta": c["mauve"],
            "terminal.ansiCyan": c["diagnostic"],
            "terminal.ansiWhite": c["text"]
        },
        "tokenColors": [
            {
                "scope": ["comment", "punctuation.definition.comment"],
                "settings": {
                    "foreground": c["comment"],
                    "fontStyle": "italic"
                }
            },
            {
                "scope": ["keyword", "storage.type", "storage.modifier", "keyword.operator"],
                "settings": {
                    "foreground": c["accent"],
                    "fontStyle": "bold"
                }
            },
            {
                "scope": ["entity.name.function", "support.function", "entity.name.method"],
                "settings": {
                    "foreground": c["diagnostic"]
                }
            },
            {
                "scope": ["string", "punctuation.definition.string"],
                "settings": {
                    "foreground": c["sage"]
                }
            },
            {
                "scope": ["constant.numeric", "constant.language"],
                "settings": {
                    "foreground": c["accent_2"]
                }
            },
            {
                "scope": ["support.type", "entity.name.type", "entity.name.class"],
                "settings": {
                    "foreground": c["lavender"]
                }
            },
            {
                "scope": ["variable", "meta.definition.variable"],
                "settings": {
                    "foreground": c["text"]
                }
            }
        ]
    }, indent=2)

def readme_content() -> str:
    return """# Dreamcoder Palette Layer

This directory contains the Dreamcoder visual contract and generated color-only snippets for ML4W/Gentleman Dots.

- `tokens.json`: canonical Dreamcoder OS design tokens and guardrails.
- `tokens.schema.json`: machine-readable token contract.
- `*-dark.*`: Dreamcoder Ember Noir mode with espresso glass, refined orange/red protagonists, and gold support accents.
- `*-light.*`: paper-like daytime mode with flat surface ladder and distinct semantic tokens.
- `*-dusk.*`: warm transitional mode (16:00–18:00) between light and dark.

## Color-only Snippets (Hooks)

Hook these into your app configs after ML4W/Gentleman files:

| Target | Files | How to Use |
|--------|-------|------------|
| **Kitty** | `kitty-dreamcoder-{mode}.conf`, `dreamcoder-ui.conf` | `include` in kitty.conf |
| **Ghostty** | `ghostty-dreamcoder-{mode}` | `theme = dreamcoder-{mode}` in ghostty config |
| **Warp** | `Warp/.local/share/warp-terminal/themes/Dreamcoder-{Mode}.yaml` | Select in Warp theme picker |
| **Hyprland** | `hyprland-{mode}.conf` | `source` from hyprland.conf |
| **Waybar** | `waybar-{mode}.css` | `@import` in waybar style.css |
| **Rofi** | `rofi-{mode}.rasi` | `@import` or `-theme` in rofi launch |
| **Starship** | `starship-{mode}.toml` | `STARSHIP_CONFIG` env var |
| **Antigravity** | `Antigravity/Dreamcoder-{Mode}.json` | Antigravity theme selector |
| **opencode** | `opencode/dreamcoder.json` | `theme: "dreamcoder"` in opencode config |
| **Codex CLI** | `Codex-CLI/Dreamcoder-{Mode}.tmTheme` | `theme = "Dreamcoder"` in codex config |
| **PI CLI** | `Pi/.pi/agent/themes/dreamcoder-{mode}.json` | `theme: "dreamcoder"` in pi settings |
| **Neovim** | `nvim-dreamcoder-{mode}.lua` | `require('dreamcoder')` in neovim config |
| **Zsh-syntax-highlighting** | `zsh-syntax-highlighting-dreamcoder-{mode}.zsh` | `source` after zsh-syntax-highlighting plugin |
| **LS_COLORS / eza** | `ls-colors-dreamcoder-{mode}.sh` | `source` in .zshrc or .bashrc |
| **Bat** | `bat-dreamcoder-{mode}.sh` | Sets `BAT_THEME` env var; pair with Codex CLI tmTheme |
| **Delta (git diff)** | `delta-dreamcoder-{mode}.gitconfig` | `[include]` in ~/.config/git/config |
| **Fzf** | `fzf-dreamcoder-{mode}.sh` | `source` in .zshrc or .bashrc |
| **Btop** | `btop-dreamcoder-{mode}.theme` | Place in ~/.config/btop/themes/ |
| **Dunst** | `dunst-dreamcoder-{mode}.conf` | `[include]` in dunstrc |
| **Firefox** | `firefox-dreamcoder-{mode}.css` | userChrome.css for Firefox customization |
| **Obsidian** | `obsidian-dreamcoder-{mode}.css` | CSS snippet in Obsidian vault |
| **Cava** | `cava-dreamcoder-{mode}.config` | `include` in ~/.config/cava/config |

## Word of Caution

Import these snippets after existing ML4W/Gentleman files so layouts, keybinds, wallpaper scripts, gaps, animations, and behavior remain owned by those systems.
"""
