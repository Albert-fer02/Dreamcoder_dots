"""Desktop shell and editor theme renderer registry."""

from __future__ import annotations

from .renderers_antigravity import antigravity_content
from .renderers_hypr_waybar_rofi import (
    hypr_colors_conf_content,
    hypr_colors_lua_content,
    hypr_content,
    rofi_content,
    rofi_matugen_content,
    waybar_content,
    waybar_matugen_content,
)
from .renderers_readme import readme_content

__all__ = [
    "hypr_content",
    "hypr_colors_lua_content",
    "hypr_colors_conf_content",
    "waybar_content",
    "waybar_matugen_content",
    "rofi_content",
    "rofi_matugen_content",
    "antigravity_content",
    "readme_content",
]
