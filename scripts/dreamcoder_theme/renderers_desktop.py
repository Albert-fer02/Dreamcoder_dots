"""Desktop shell and editor theme renderer registry."""

from __future__ import annotations

from .renderers_antigravity import antigravity_content
from .renderers_hypr_waybar_rofi import hypr_content, rofi_content, waybar_content
from .renderers_readme import readme_content

__all__ = ["hypr_content", "waybar_content", "rofi_content", "antigravity_content", "readme_content"]
