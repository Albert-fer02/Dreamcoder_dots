import json
import os
import shutil
import subprocess
import sys
from pathlib import Path

from dreamcoder_theme.palette import load_variants
from dreamcoder_theme.palette_tokens import VARIANTS
from dreamcoder_theme.renderers_opencode import opencode_content

ROOT = Path(__file__).resolve().parents[1]
HEALTH_SCRIPT = ROOT / "scripts" / "verify-theme-health.py"
THEME_ROOT = ROOT / "DreamcoderThemes" / "dreamcoder"


def build_health_fixture(tmp_path: Path) -> Path:
    fixture_root = tmp_path / "fixture"
    script_dir = fixture_root / "scripts"
    script_dir.mkdir(parents=True)
    shutil.copy2(HEALTH_SCRIPT, script_dir / HEALTH_SCRIPT.name)
    shutil.copy2(
        ROOT / "scripts" / "generate-palette-tokens.py", script_dir / "generate-palette-tokens.py"
    )
    generated_root = fixture_root / "src" / "dreamcoder_theme"
    generated_root.mkdir(parents=True)
    shutil.copy2(ROOT / "src" / "dreamcoder_theme" / "palette_tokens.py", generated_root)
    theme_root = fixture_root / "DreamcoderThemes" / "dreamcoder"
    shutil.copytree(THEME_ROOT, theme_root)
    token_path = theme_root / "tokens.json"
    tokens = json.loads(token_path.read_text())
    token_path.write_text(json.dumps(tokens))
    return fixture_root


def run_health(fixture_root: Path) -> subprocess.CompletedProcess[str]:
    environment = os.environ | {"PYTHONPATH": str(ROOT / "src")}
    return subprocess.run(
        [sys.executable, "scripts/verify-theme-health.py"],
        cwd=fixture_root,
        env=environment,
        capture_output=True,
        text=True,
        check=False,
    )


def test_health_checks_managed_opencode_theme_root_not_application_config(tmp_path):
    fixture_root = build_health_fixture(tmp_path)
    managed_theme_dir = fixture_root / ".opencode" / "themes"
    managed_theme_dir.mkdir(parents=True)
    variants = load_variants(
        VARIANTS, fixture_root / "DreamcoderThemes" / "dreamcoder" / "tokens.json"
    )
    (managed_theme_dir / "dreamcoder.json").write_text(
        opencode_content(variants["light"], transparent_background=True)
    )

    app_config_dir = fixture_root / "DreamcoderOpenCode" / ".config" / "opencode"
    app_config_dir.mkdir(parents=True)
    (app_config_dir / "opencode.json").write_text('{"theme": "dreamcoder"}')

    result = run_health(fixture_root)

    assert result.returncode == 0, result.stderr


def test_health_fails_for_design_system_contract_findings(tmp_path):
    fixture_root = build_health_fixture(tmp_path)
    managed_theme_dir = fixture_root / ".opencode" / "themes"
    managed_theme_dir.mkdir(parents=True)
    variants = load_variants(
        VARIANTS, fixture_root / "DreamcoderThemes" / "dreamcoder" / "tokens.json"
    )
    (managed_theme_dir / "dreamcoder.json").write_text(
        opencode_content(variants["light"], transparent_background=True)
    )

    legacy_theme_dir = fixture_root / "DreamcoderOpenCode" / ".config" / "opencode"
    legacy_theme_dir.mkdir(parents=True)
    (legacy_theme_dir / "dreamcoder.json").write_text("{}")

    contract_path = fixture_root / "DreamcoderThemes" / "dreamcoder" / "design-system.json"
    contract = json.loads(contract_path.read_text())
    contract["targets"]["opencode"]["modes"] = ["dark", "light"]
    contract_path.write_text(json.dumps(contract))

    result = run_health(fixture_root)

    assert result.returncode != 0
    assert "design-system:MISSING_TARGET_MODE" in result.stderr


def test_health_rejects_stale_opencode_artifact_with_actionable_code(tmp_path):
    fixture_root = build_health_fixture(tmp_path)
    managed_theme_dir = fixture_root / ".opencode" / "themes"
    managed_theme_dir.mkdir(parents=True)
    (managed_theme_dir / "dreamcoder.json").write_text('{"theme": {"text": "#000000"}}')

    result = run_health(fixture_root)

    assert result.returncode != 0
    assert "STALE_ARTIFACT" in result.stderr


def test_health_rejects_malformed_opencode_artifact(tmp_path):
    fixture_root = build_health_fixture(tmp_path)
    managed_theme_dir = fixture_root / ".opencode" / "themes"
    managed_theme_dir.mkdir(parents=True)
    (managed_theme_dir / "dreamcoder.json").write_text("{")

    result = run_health(fixture_root)

    assert result.returncode != 0
    assert "MALFORMED_ARTIFACT" in result.stderr


def test_health_reports_schema_and_malformed_artifact_when_path_is_missing(tmp_path):
    fixture_root = build_health_fixture(tmp_path)
    contract_path = fixture_root / "DreamcoderThemes" / "dreamcoder" / "design-system.json"
    contract = json.loads(contract_path.read_text())
    artifact = next(item for item in contract["artifacts"] if item["id"] == "opencode-default")
    del artifact["path"]
    contract_path.write_text(json.dumps(contract))

    result = run_health(fixture_root)

    assert result.returncode != 0
    assert "SCHEMA_INVALID" in result.stderr
    assert "MALFORMED_ARTIFACT: opencode-default missing path" in result.stderr
    assert "KeyError" not in result.stderr
