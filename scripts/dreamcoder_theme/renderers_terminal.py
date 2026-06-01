"""Terminal and prompt theme renderer registry."""

from __future__ import annotations

from .renderers_ghostty_warp import ghostty_content, warp_content
from .renderers_kitty import kitty_content, kitty_ui_content
from .renderers_starship import starship_content

__all__ = ["kitty_content", "kitty_ui_content", "ghostty_content", "warp_content", "starship_content"]
