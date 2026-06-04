"""Extra theme renderer registry for Dreamcoder ecosystem expansion."""

from __future__ import annotations

from .renderers_extra_firefox import firefox_content
from .renderers_extra_obsidian import obsidian_content
from .renderers_extra_nvim import nvim_content
from .renderers_extra_shell import fzf_content, ls_colors_content, zsh_syntax_content
from .renderers_extra_bat_delta import bat_content, delta_content
from .renderers_extra_btop import btop_content
from .renderers_extra_notify import cava_content, dunst_content

__all__ = [
    "bat_content",
    "btop_content",
    "cava_content",
    "delta_content",
    "dunst_content",
    "firefox_content",
    "fzf_content",
    "ls_colors_content",
    "nvim_content",
    "obsidian_content",
    "zsh_syntax_content",
]
