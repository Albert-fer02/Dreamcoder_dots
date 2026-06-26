import json
import os
import subprocess
import sys
import tempfile
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
CONTROL = ROOT / "src" / "dreamcoder_theme" / "control.py"


def run_control(*args: str, home: Path | None = None) -> subprocess.CompletedProcess[str]:
    env = os.environ.copy()
    env["PYTHONPATH"] = str(ROOT / "src")
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


class DreamcoderTuiTest(unittest.TestCase):
    def test_tui_render_json_exposes_settings_model(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            home = Path(tmpdir)
            result = run_control("tui", "render", "--json", home=home)
            self.assertEqual(result.returncode, 0, result.stderr)
            data = json.loads(result.stdout)
            self.assertEqual(data["schema"], "dreamcoder.tui.v1")
            self.assertEqual(data["title"], "Dreamcoder Settings")
            keys = {row["key"] for row in data["settings"]}
            self.assertIn("terminal.default_mode", keys)
            self.assertIn("motion.active", keys)
            self.assertIn("dry_run_set", data["commands"])

    def test_tui_render_text_is_terminal_friendly(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            home = Path(tmpdir)
            result = run_control("tui", "render", home=home)
            self.assertEqual(result.returncode, 0, result.stderr)
            self.assertIn("Dreamcoder Settings", result.stdout)
            self.assertIn("terminal.default_mode", result.stdout)
            self.assertIn("--dry-run", result.stdout)

    def test_tui_set_dry_run_does_not_write_settings(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            home = Path(tmpdir)
            result = run_control(
                "tui", "set", "terminal.default_mode", "dark", "--dry-run", "--json", home=home
            )
            self.assertEqual(result.returncode, 0, result.stderr)
            data = json.loads(result.stdout)
            self.assertEqual(data["schema"], "dreamcoder.tui-apply.v1")
            self.assertTrue(data["dry_run"])
            self.assertFalse((home / ".config" / "dreamcoder" / "settings.json").exists())

    def test_tui_set_applies_valid_setting_and_rejects_invalid_value(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            home = Path(tmpdir)
            applied = run_control(
                "tui", "set", "terminal.default_mode", "dark", "--json", home=home
            )
            self.assertEqual(applied.returncode, 0, applied.stderr)
            settings = json.loads((home / ".config" / "dreamcoder" / "settings.json").read_text())
            self.assertEqual(settings["terminal"]["default_mode"], "dark")

            invalid = run_control(
                "tui", "set", "terminal.default_mode", "neon", "--json", home=home
            )
            self.assertEqual(invalid.returncode, 2)
            self.assertIn("terminal.default_mode must be one of", invalid.stderr)


if __name__ == "__main__":
    unittest.main()
