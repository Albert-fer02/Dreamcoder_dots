"""Pure, profile-gated renderer for repository-owned Herdr variants."""

from __future__ import annotations

import re

from .herdr_contract import HerdrProfile

_HEX_COLOR = re.compile(r"#[0-9a-fA-F]{6}\Z")
_UI_FIELD_RHS = {
    "accent": '"#6FA0AF"',
    "pane_scrollbars": "false",
}
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


class HerdrModeError(Exception):
    """Raised when a Herdr variant mode is not the supported dark or light set."""


def herdr_content(profile: HerdrProfile, mode: str, palette: dict[str, str]) -> str:
    """Render one static Light, Dark, or Night variant without touching active configuration."""
    if not profile.is_complete:
        raise HerdrContractUnavailableError("Herdr color rendering requires a complete profile")
    if mode not in {"dark", "light", "night"}:
        raise HerdrModeError("Herdr supports only dark, light, and night variants")

    evidence = profile.evidence
    if "name" not in evidence.allowed_theme_fields:
        raise HerdrContractUnavailableError("Herdr profile does not allow theme.name")

    custom_lines: list[str] = []
    for field, token in _TOKEN_MAPPING:
        if field not in evidence.allowed_custom_fields:
            raise HerdrContractUnavailableError(
                f"Herdr profile does not allow theme.custom.{field}"
            )
        color = palette.get(token)
        if not isinstance(color, str) or _HEX_COLOR.fullmatch(color) is None:
            raise HerdrContractUnavailableError(
                f"Herdr palette token {token!r} must be a #RRGGBB color"
            )
        custom_lines.append(f'{field} = "{color}"')

    ui_lines: list[str] = []
    for field in evidence.allowed_ui_fields:
        rhs = _UI_FIELD_RHS.get(field)
        if rhs is None:
            raise HerdrContractUnavailableError(
                f"Herdr profile requests unsupported [ui] field {field!r}"
            )
        ui_lines.append(f"{field} = {rhs}")

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
            *ui_lines,
            "",
            "[keys]",
            *_KEYS_LINES,
            "",
        )
    )


def herdr_token_mapping() -> tuple[tuple[str, str], ...]:
    """Expose the fixed documented-field to canonical-token mapping for tests."""
    return _TOKEN_MAPPING


def herdr_ui_field_rhs() -> dict[str, str]:
    """Expose the evidence-bound [ui] field right-hand sides for tests."""
    return dict(_UI_FIELD_RHS)
