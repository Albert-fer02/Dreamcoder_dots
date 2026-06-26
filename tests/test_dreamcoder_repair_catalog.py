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


class DreamcoderRepairCatalogTest(unittest.TestCase):
    def test_repair_catalog_exposes_multiple_safe_repairs(self):
        result = run_control("repair", "catalog", "--json")
        self.assertEqual(result.returncode, 0, result.stderr)
        data = json.loads(result.stdout)
        self.assertEqual(data["schema"], "dreamcoder.repair-catalog.v1")
        self.assertGreaterEqual(len(data["safe_repairs"]), 6)
        self.assertIn("restore-kitty-config", data["safe_repairs"])

    def test_repair_plan_marks_missing_managed_configs_safe(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            home = Path(tmpdir)
            result = run_control("repair", "plan", "--json", home=home)
            self.assertEqual(result.returncode, 0, result.stderr)
            data = json.loads(result.stdout)
            actions = {action["id"]: action for action in data["actions"]}
            self.assertTrue(actions["restore-kitty-config"]["safe"])
            self.assertIn("source", actions["restore-kitty-config"])

    def test_repair_apply_restores_missing_kitty_config_with_backup(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            home = Path(tmpdir)
            target = home / ".config" / "kitty"
            result = run_control("repair", "apply", "--json", home=home)
            self.assertEqual(result.returncode, 0, result.stderr)
            data = json.loads(result.stdout)
            self.assertIn("backup_id", data)
            self.assertTrue(target.is_symlink())
            self.assertTrue(target.resolve().is_dir())
            manifest = (
                home
                / ".local"
                / "share"
                / "dreamcoder"
                / "backups"
                / data["backup_id"]
                / "manifest.json"
            )
            self.assertTrue(manifest.exists())


if __name__ == "__main__":
    unittest.main()
