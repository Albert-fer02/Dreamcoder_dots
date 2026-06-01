import json
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
TOKENS = ROOT / "themes" / "dreamcoder" / "tokens.json"
DESIGN_SYSTEM_DOC = ROOT / "docs" / "DREAMCODER_DESIGN_SYSTEM.md"


def _rgb(value: str) -> tuple[int, int, int]:
    value = value.lstrip("#")
    return tuple(int(value[i : i + 2], 16) for i in (0, 2, 4))


def _srgb_lin(channel: int) -> float:
    scaled = channel / 255
    return scaled / 12.92 if scaled <= 0.040448236 else ((scaled + 0.055) / 1.055) ** 2.4


def _apca_y(value: str) -> float:
    r, g, b = (_srgb_lin(part) for part in _rgb(value))
    return (0.2126729 * r + 0.7151522 * g + 0.0721750 * b) ** 0.56


def apca_lc(foreground: str, background: str) -> float:
    y_fg, y_bg = _apca_y(foreground), _apca_y(background)
    if y_bg >= y_fg:
        return (y_bg - y_fg) * 1.14 * 100
    return (y_fg - y_bg) * 1.14 * 100


def test_dark_body_diagnostics_meet_apca_floor():
    tokens = json.loads(TOKENS.read_text())
    dark = tokens["modes"]["dark"]
    floor = tokens["guardrails"]["minimum_apca_body_dark"]

    assert apca_lc(dark["diagnostic"], dark["bg"]) >= floor


def test_global_design_system_doc_exists_with_operational_governance():
    assert DESIGN_SYSTEM_DOC.exists()
    text = DESIGN_SYSTEM_DOC.read_text()

    required_sections = [
        "## Product definition",
        "## Token contract",
        "## Component model",
        "## Accessibility policy",
        "## Governance",
        "## Release readiness checklist",
    ]
    for section in required_sections:
        assert section in text

    assert re.search(r"Versioned token schema", text)
    assert re.search(r"visual regression", text, re.IGNORECASE)
    assert re.search(r"WCAG", text)
    assert re.search(r"APCA", text)


def test_governance_artifacts_are_linked_from_readme_and_changelog():
    readme = (ROOT / "README.md").read_text()
    changelog = ROOT / "CHANGELOG.md"

    assert "docs/DREAMCODER_DESIGN_SYSTEM.md" in readme
    assert changelog.exists()
    text = changelog.read_text()
    assert "## Unreleased" in text
    assert "Design system governance" in text
    assert "APCA" in text
