import importlib.util
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
GENERATOR = ROOT / "scripts" / "generate-palette-tokens.py"


def load_generator():
    spec = importlib.util.spec_from_file_location("palette_generator", GENERATOR)
    assert spec is not None and spec.loader is not None
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def test_check_generated_detects_exact_byte_drift_without_writing(tmp_path):
    generator = load_generator()
    output = tmp_path / "palette_tokens.py"
    output.write_text("stale\n", encoding="utf-8")

    drift = generator.check_generated(generator.TOKENS_FILE, output)

    assert drift is not None
    assert drift.startswith("GENERATED_DRIFT:")
    assert "canonical source=DreamcoderThemes/dreamcoder/tokens.json" in drift
    assert output.read_text(encoding="utf-8") == "stale\n"


def test_check_generated_accepts_canonical_bytes(tmp_path):
    generator = load_generator()
    output = tmp_path / "palette_tokens.py"
    output.write_text(generator.render_from_tokens(generator.load_tokens()), encoding="utf-8")

    assert generator.check_generated(generator.TOKENS_FILE, output) is None
