import json
import re
from pathlib import Path

from dreamcoder_theme._math import apca_lc, contrast

ROOT = Path(__file__).resolve().parents[1]
TOKENS = ROOT / "DreamcoderThemes" / "dreamcoder" / "tokens.json"
DESIGN_SYSTEM_DOC = ROOT / "docs" / "DREAMCODER_DESIGN_SYSTEM.md"


def test_dark_body_diagnostics_meet_apca_floor():
    """Blocking APCA check against the canonical dark body floor (50)."""
    tokens = json.loads(TOKENS.read_text())
    dark = tokens["modes"]["dark"]
    floor = tokens["guardrails"]["minimum_apca_body_dark"]

    for key in ("text", "diagnostic", "error", "warning"):
        lc = abs(apca_lc(dark[key], dark["bg"]))
        assert lc >= floor, f"dark:{key} APCA Lc {lc:.1f} < floor {floor}"
        assert contrast(dark["bg"], dark[key]) >= 4.5


def test_dark_heading_meets_apca_floor():
    """Blocking APCA check against the canonical dark heading floor (45)."""
    tokens = json.loads(TOKENS.read_text())
    dark = tokens["modes"]["dark"]
    floor = tokens["guardrails"]["minimum_apca_heading_dark"]
    lc = abs(apca_lc(dark["text_heading"], dark["bg"]))
    assert lc >= floor, f"dark:text_heading APCA Lc {lc:.1f} < floor {floor}"


def test_dark_main_text_meets_wcag_aaa():
    """WCAG remains the independent legal floor: main text stays at AAA (7.0)."""
    tokens = json.loads(TOKENS.read_text())
    dark = tokens["modes"]["dark"]
    assert contrast(dark["bg"], dark["text"]) >= 7.0


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

    assert "docs/" in readme
    assert changelog.exists()
    text = changelog.read_text()
    assert "## Unreleased" in text
    assert "Design system governance" in text
    assert "APCA" in text
