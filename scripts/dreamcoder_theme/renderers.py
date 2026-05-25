"""Public renderer exports grouped by application family."""

from .renderers_cli import (
    codex_tmtheme_content,
    opencode_content,
    opencode_tokens,
    pi_theme_content,
)
from .renderers_desktop import (
    antigravity_content,
    hypr_content,
    readme_content,
    rofi_content,
    waybar_content,
)
from .renderers_terminal import (
    ghostty_content,
    kitty_content,
    kitty_ui_content,
    starship_content,
    warp_content,
)

__all__ = [
    "antigravity_content",
    "codex_tmtheme_content",
    "ghostty_content",
    "hypr_content",
    "kitty_content",
    "kitty_ui_content",
    "opencode_content",
    "opencode_tokens",
    "pi_theme_content",
    "readme_content",
    "rofi_content",
    "starship_content",
    "warp_content",
    "waybar_content",
]
