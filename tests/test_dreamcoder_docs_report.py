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


class DreamcoderDocsReportTest(unittest.TestCase):
    def test_docs_report_json_exposes_visual_sections_and_contracts(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            result = run_control("docs", "report", "--json", home=Path(tmpdir))
            self.assertEqual(result.returncode, 0, result.stderr)
            data = json.loads(result.stdout)
            self.assertEqual(data["schema"], "dreamcoder.docs-report.v1")
            self.assertIn("visual-dashboard", data["sections"])
            self.assertIn("dreamcoder.tui.v1", data["contracts"])
            self.assertIn("tui_preview", data)

    def test_docs_report_markdown_is_visual_and_competitive(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            result = run_control("docs", "report", "--markdown", home=Path(tmpdir))
            self.assertEqual(result.returncode, 0, result.stderr)
            self.assertIn("# Dreamcoder Operator Report", result.stdout)
            self.assertIn("Dreamcoder Health", result.stdout)
            self.assertIn("Competitive Checklist", result.stdout)

    def test_docs_report_write_creates_generated_report(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            result = run_control("docs", "report", "--write", "--json", home=Path(tmpdir))
            self.assertEqual(result.returncode, 0, result.stderr)
            data = json.loads(result.stdout)
            report = ROOT / data["path"]
            self.assertTrue(report.exists())
            self.assertIn("Dreamcoder Operator Report", report.read_text())


if __name__ == "__main__":
    unittest.main()
