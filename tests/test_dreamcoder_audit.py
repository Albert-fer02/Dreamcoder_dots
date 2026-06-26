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


class DreamcoderAuditTest(unittest.TestCase):
    def test_audit_compare_json_exposes_score_and_remaining_gaps(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            result = run_control("audit", "compare", "--json", home=Path(tmpdir))
            self.assertEqual(result.returncode, 0, result.stderr)
            data = json.loads(result.stdout)
            self.assertEqual(data["schema"], "dreamcoder.audit.v1")
            self.assertIn("score", data["summary"])
            self.assertGreaterEqual(data["summary"]["achieved"], 1)
            keys = {item["key"] for item in data["criteria"]}
            self.assertIn("control-center-contracts", keys)
            self.assertIn("smart-doctor-repair", keys)
            self.assertIn("remaining_gaps", data)

    def test_audit_compare_markdown_is_human_readable(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            result = run_control("audit", "compare", "--markdown", home=Path(tmpdir))
            self.assertEqual(result.returncode, 0, result.stderr)
            self.assertIn("# Dreamcoder Competitive Audit", result.stdout)
            self.assertIn("Capability", result.stdout)
            self.assertIn("ML4W", result.stdout)


if __name__ == "__main__":
    unittest.main()
