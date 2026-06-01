import json
import os
import subprocess
import sys
import tempfile
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
CONTROL = ROOT / "scripts" / "dreamcoder_theme" / "control.py"


def run_control(*args: str, home: Path | None = None):
    env = os.environ.copy()
    env["PYTHONPATH"] = str(ROOT / "scripts")
    if home is not None:
        env["HOME"] = str(home)
        env["XDG_CONFIG_HOME"] = str(home / ".config")
        env["XDG_DATA_HOME"] = str(home / ".local" / "share")
    return subprocess.run(
        [sys.executable, str(CONTROL), *args],
        cwd=ROOT,
        env=env,
        text=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        check=False,
    )


class DreamcoderVisualRegressionTest(unittest.TestCase):
    def test_visual_plan_json_lists_required_screenshot_targets(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            result = run_control("visual", "plan", "--json", home=Path(tmpdir))
            self.assertEqual(result.returncode, 0, result.stderr)
            data = json.loads(result.stdout)
            self.assertEqual(data["schema"], "dreamcoder.visual-regression-plan.v1")
            keys = {target["key"] for target in data["targets"]}
            self.assertGreaterEqual(keys, {"neovim", "kitty", "ghostty", "waybar", "rofi", "codex-cli", "opencode"})
            self.assertTrue(all(target["baseline"] for target in data["targets"]))

    def test_visual_plan_markdown_is_documented_and_actionable(self):
        result = run_control("visual", "plan", "--markdown")
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertIn("# Dreamcoder Visual Regression Plan", result.stdout)
        self.assertIn("Baseline", result.stdout)
        self.assertIn("Capture command", result.stdout)


if __name__ == "__main__":
    unittest.main()
