"""Duplicate-formula regression guard (ADR-001).

The SAPC/APCA 0.0.98G-4g implementation lives ONLY in
``src/dreamcoder_theme/_math.py``. The three former duplicate locations —
``scripts/verify-theme-health.py``, ``scripts/generate-theme-preview.py``, and
``tests/test_dreamcoder_global_design_system.py`` — must import the package
implementation and must not carry their own copy of the constants or formula.
A reintroduced copy fails this test in CI.
"""

from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]

# Markers that are unique to the SAPC/APCA formula or its version banner.
SAPC_MARKERS = (
    "0.98G",
    "def apca_lc",
    "def apca_y",
    "_APCA_R",
    "_NORM_TXT",
    "_REV_TXT",
    "_BLK_THRS",
    "27.7847239587675",
    "soft_clamp",
)

FORMER_DUPLICATE_LOCATIONS = (
    ROOT / "scripts" / "verify-theme-health.py",
    ROOT / "scripts" / "generate-theme-preview.py",
    ROOT / "tests" / "test_dreamcoder_global_design_system.py",
)

PACKAGE_IMPORT_LINE = "from dreamcoder_theme._math import apca_lc"


def test_no_sapc_formula_in_former_duplicate_locations():
    for path in FORMER_DUPLICATE_LOCATIONS:
        assert path.is_file(), f"former duplicate location missing: {path}"
        source = path.read_text(encoding="utf-8")
        for marker in SAPC_MARKERS:
            assert marker not in source, f"{path.name} contains duplicated APCA marker {marker!r}"


def test_former_duplicates_import_the_package_implementation():
    for path in FORMER_DUPLICATE_LOCATIONS:
        source = path.read_text(encoding="utf-8")
        assert PACKAGE_IMPORT_LINE in source, f"{path.name} must import apca_lc from the package"
