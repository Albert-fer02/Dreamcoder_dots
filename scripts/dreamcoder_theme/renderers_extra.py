"""Extra theme renderer registry for Dreamcoder ecosystem expansion."""

from __future__ import annotations

from .renderers_extra_firefox import firefox_content
from .renderers_extra_obsidian import obsidian_content
from .renderers_extra_nvim import nvim_content
from .renderers_extra_shell import fzf_content, ls_colors_content, zsh_syntax_content
from .renderers_extra_bat_delta import bat_content, delta_content
from .renderers_extra_btop import btop_content
from .renderers_extra_notify import cava_content, dunst_content

_EXTRA_RENDERERS = {
    "nvim": nvim_content,
    "zsh_syntax": zsh_syntax_content,
    "ls_colors": ls_colors_content,
    "bat": bat_content,
    "delta": delta_content,
    "fzf": fzf_content,
    "btop": btop_content,
    "dunst": dunst_content,
    "firefox": firefox_content,
    "obsidian": obsidian_content,
    "cava": cava_content,
}

__all__ = list(_EXTRA_RENDERERS.keys()) + ["_EXTRA_RENDERERS"]
