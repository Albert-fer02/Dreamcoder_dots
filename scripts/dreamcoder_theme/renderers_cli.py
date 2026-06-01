"""CLI/editor theme renderer registry."""

from __future__ import annotations

from .renderers_codex import codex_tmtheme_content
from .renderers_opencode import opencode_content, opencode_tokens
from .renderers_pi import pi_theme_content

__all__ = ["pi_theme_content", "opencode_tokens", "opencode_content", "codex_tmtheme_content"]
