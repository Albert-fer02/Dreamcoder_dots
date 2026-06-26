"""Tests for the audit module (subprocess integration + direct unit tests)."""

from __future__ import annotations

import json
import os
import subprocess
import sys
import tempfile
import unittest
from pathlib import Path

from dreamcoder_theme.audit import audit_markdown, audit_report

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
        capture_output=True,
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

    # ------------------------------------------------------------------
    # Direct unit tests for audit_report() and audit_markdown()
    # ------------------------------------------------------------------

    def test_audit_report_returns_structured_dict(self):
        report = audit_report()
        self.assertEqual(report["schema"], "dreamcoder.audit.v1")
        self.assertIn("summary", report)
        self.assertIn("score", report["summary"])
        self.assertIn("achieved", report["summary"])
        self.assertIn("criteria", report)
        self.assertIsInstance(report["criteria"], list)
        self.assertGreater(len(report["criteria"]), 0)
        for item in report["criteria"]:
            self.assertIn("key", item)
            self.assertIn("status", item)
            self.assertIn("evidence", item)
            self.assertIn("baseline", item)

    def test_audit_report_remaining_gaps_is_subset(self):
        report = audit_report()
        for gap in report["remaining_gaps"]:
            self.assertNotEqual(gap["status"], "achieved")

    def test_audit_markdown_contains_all_criteria(self):
        report = audit_report()
        md = audit_markdown(report)
        self.assertIn("# Dreamcoder Competitive Audit", md)
        self.assertIn("| Capability | Status |", md)
        self.assertIn("score", md.lower())
        for item in report["criteria"]:
            self.assertIn(item["key"], md)

    def test_audit_markdown_includes_score_line(self):
        report = audit_report()
        md = audit_markdown(report)
        self.assertIn(f"- Score: `{report['summary']['score']}`", md)
        self.assertIn(f"- Achieved: `{report['summary']['achieved']}`", md)

    def test_audit_criterion_has_expected_keys(self):
        report = audit_report()
        for item in report["criteria"]:
            self.assertEqual(
                sorted(item.keys()), sorted(["key", "status", "evidence", "baseline", "next_step"])
            )
            self.assertIn(item["status"], {"achieved", "partial", "missing"})
            self.assertIsInstance(item["key"], str)


if __name__ == "__main__":
    unittest.main()
