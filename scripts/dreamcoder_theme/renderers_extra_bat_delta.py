"""Focused extra Dreamcoder theme renderers."""

from __future__ import annotations

from .palette import guard, mix
from .renderers_core import ansi


def bat_content(c: dict[str, str]) -> str:
    """Return a Bat theme config snippet with modern defaults."""
    mode_name = "dark" if c["details"] == "darker" else "light"
    theme = "Dreamcoder-Dark" if mode_name == "dark" else "Dreamcoder-Light"
    return (
        "#!/usr/bin/env bash\n"
        "set -euo pipefail\n"
        f"# {c['name']} — Bat theme; run 'bat cache --build' after installing the tmTheme.\n"
        f'export BAT_THEME="{theme}"\n'
        'export BAT_STYLE="auto,changes,header,grid"\n'
        'export BAT_PAGER="less -RF"\n'
        'export BAT_TABS="4"\n'
    )


def delta_content(c: dict[str, str]) -> str:
    """Return a Git Delta config snippet with Dreamcoder colors."""
    mode = "dark" if c["details"] == "darker" else "light"
    bg = c["bg"]

    def g(color: str) -> str:
        return guard(c[color], bg, mode)

    plus_bg = mix(c["sage"], bg, 0.85)
    minus_bg = mix(c["error"], bg, 0.85)

    return f"""# ========================================================
# {c["name"]} — Git Delta theme
# ========================================================
# Include from ~/.config/git/config:
#   [include]
#       path = ~/.config/git/delta-dreamcoder.gitconfig

[delta]
    # Syntax highlighting theme for diff content
    syntax-theme = Dreamcoder-{"Dark" if mode == "dark" else "Light"}

    # Line colors
    plus-color = "{plus_bg}"
    minus-color = "{minus_bg}"
    plus-emph-color = "{g("sage")}"
    minus-emph-color = "{g("error")}"

    # Diff UI
    file-style = "{g("accent")}"
    file-decoration-style = "bold yellow box ul"
    hunk-header-style = "file line-number syntax"
    hunk-header-decoration-style = "yellow box"
    hunk-header-file-style = "{g("accent")}"
    hunk-header-line-number-style = "#{g("muted")}"
    hunk-header-color = "{mix(g("muted"), bg, 0.85)}"

    # Commit decorations
    commit-style = "{g("accent")} bold"
    commit-decoration-style = "bold yellow box ul"

    # Line numbers
    line-numbers = true
    line-numbers-left-style = "{g("muted")}"
    line-numbers-right-style = "{g("muted")}"
    line-numbers-minus-style = "{g("error")}"
    line-numbers-plus-style = "{g("sage")}"

    # Side-by-side
    side-by-side = true

    # Whitespace highlighting
    whitespace-error-style = "{g("warning")}"

    # Navigation
    navigate = true
"""
