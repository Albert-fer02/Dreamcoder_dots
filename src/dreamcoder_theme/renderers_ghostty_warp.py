"""Focused terminal and prompt theme renderers."""

from __future__ import annotations

from .palette import ansi


def ghostty_content(c: dict[str, str]) -> str:
    is_dark = c["details"] == "darker"
    sel_bg = c["selection_bg"]
    sel_fg = c["selection_fg"]
    opacity = "0.76" if is_dark else "0.96"
    blur = "true" if is_dark else "false"
    lines = [
        f"# {c['name']}",
        f"background = {c['bg']}",
        f"foreground = {c['text']}",
        f"cursor-color = {c['accent']}",
        f"cursor-text = {c['on_accent']}",
        f"selection-background = {sel_bg}",
        f"selection-foreground = {sel_fg}",
        f"background-opacity = {opacity}",
        f"background-blur = {blur}",
        "minimum-contrast = 4.5",
        "",
    ]
    lines.extend(f"palette = {i}={color}" for i, color in enumerate(ansi(c)))
    return "\n".join(lines) + "\n"


def warp_content(c: dict[str, str]) -> str:
    p = ansi(c)
    return f"""name: {c["name"]}
accent: '{c["accent"]}'
cursor: '{c["accent"]}'
background: '{c["bg"]}'
foreground: '{c["text"]}'
details: {c["details"]}
terminal_colors:
  normal:
    black: '{p[0]}'
    red: '{p[1]}'
    green: '{p[2]}'
    yellow: '{p[3]}'
    blue: '{p[4]}'
    magenta: '{p[5]}'
    cyan: '{p[6]}'
    white: '{p[7]}'
  bright:
    black: '{p[8]}'
    red: '{p[9]}'
    green: '{p[10]}'
    yellow: '{p[11]}'
    blue: '{p[12]}'
    magenta: '{p[13]}'
    cyan: '{p[14]}'
    white: '{p[15]}'
"""
