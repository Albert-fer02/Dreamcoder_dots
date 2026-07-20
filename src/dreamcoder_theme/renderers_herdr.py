"""Pure, profile-gated renderer for repository-owned Herdr variants."""

from __future__ import annotations

import re

from .herdr_contract import HerdrProfile

_HEX_COLOR = re.compile(r"#[0-9a-fA-F]{6}\Z")
_UI_LINES = ('accent = "#6FA0AF"',)
_KEYS_LINES = (
    'prefix = "ctrl+a"',
    'previous_agent = "prefix+alt+k"',
    'next_agent = "prefix+alt+j"',
    'focus_agent = "prefix+ctrl+1..9"',
)
_TOKEN_MAPPING = (
    ("accent", "accent"),
    ("panel_bg", "bg"),
    ("surface0", "surface0"),
    ("surface1", "surface1"),
    ("surface_dim", "bg_soft"),
    ("overlay0", "border_ui"),
    ("overlay1", "subtle"),
    ("text", "text"),
    ("subtext0", "muted"),
    ("mauve", "mauve"),
    ("green", "success"),
    ("yellow", "warning"),
    ("red", "error"),
    ("blue", "info"),
    ("teal", "focus"),
    ("peach", "accent_2"),
)


class HerdrContractUnavailableError(RuntimeError):
    """Raised when code attempts Herdr rendering without verified evidence."""


def herdr_content(profile: HerdrProfile, mode: str, palette: dict[str, str]) -> str:
    """Render one static Light or Dark variant without touching active configuration."""
    if not profile.is_complete:
        raise HerdrContractUnavailableError("Herdr color rendering requires a complete profile")
    if mode not in {"dark", "light"}:
        raise ValueError("Herdr supports only dark and light variants")

    evidence = profile.evidence
    if "name" not in evidence.allowed_theme_fields:
        raise HerdrContractUnavailableError("Herdr profile does not allow theme.name")

    custom_lines: list[str] = []
    for field, token in _TOKEN_MAPPING:
        if field not in evidence.allowed_custom_fields:
            raise HerdrContractUnavailableError(
                f"Herdr profile does not allow theme.custom.{field}"
            )
        value = palette.get(token)
        if not isinstance(value, str) or _HEX_COLOR.fullmatch(value) is None:
            raise ValueError(f"Herdr palette token {token!r} must be a #RRGGBB color")
        custom_lines.append(f'{field} = "{value}"')

    return "\n".join(
        (
            "# Managed by Dreamcoder; repository variant only.",
            "[theme]",
            f'name = "{evidence.base_theme_name}"',
            "",
            "[theme.custom]",
            *custom_lines,
            "",
            "[ui]",
            *_UI_LINES,
            "",
            "[keys]",
            *_KEYS_LINES,
            "",
        )
    )


def herdr_token_mapping() -> tuple[tuple[str, str], ...]:
    """Expose the fixed documented-field to canonical-token mapping for tests."""
    return _TOKEN_MAPPING
