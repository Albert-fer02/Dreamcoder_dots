import json
import os
import subprocess
import sys
import tempfile
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
CONTROL = ROOT / "scripts" / "dreamcoder_theme" / "control.py"


def run_control(*args: str, home: Path | None = None) -> subprocess.CompletedProcess[str]:
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


class DreamcoderControlCenterTest(unittest.TestCase):
    def test_profile_list_exposes_default_and_asus_profiles(self):
        result = run_control("profile", "list", "--json")
        self.assertEqual(result.returncode, 0, result.stderr)
        data = json.loads(result.stdout)
        self.assertIn("default", data["profiles"])
        self.assertIn("asus-vivobook15", data["profiles"])
        self.assertEqual(data["profiles"]["asus-vivobook15"]["keyboard_layout"], "latam")
        self.assertEqual(data["profiles"]["asus-vivobook15"]["repeat_rate"], 50)

    def test_profile_apply_dry_run_is_deterministic_and_non_destructive(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            home = Path(tmpdir)
            result = run_control(
                "profile", "apply", "asus-vivobook15", "--dry-run", "--json", home=home
            )
            self.assertEqual(result.returncode, 0, result.stderr)
            data = json.loads(result.stdout)
            self.assertTrue(data["dry_run"])
            self.assertEqual(data["profile"]["name"], "asus-vivobook15")
            self.assertIn("input:repeat_rate", data["planned_changes"])
            self.assertFalse((home / ".config" / "dreamcoder" / "profile.json").exists())

    def test_motion_presets_include_performance_cost_and_terminal_motion(self):
        result = run_control("motion", "list", "--json")
        self.assertEqual(result.returncode, 0, result.stderr)
        data = json.loads(result.stdout)
        self.assertEqual(data["presets"]["fluid"]["kitty_cursor_trail"], 1)
        self.assertLess(
            data["presets"]["battery"]["performance_cost"],
            data["presets"]["cinematic"]["performance_cost"],
        )

    def test_settings_set_and_get_round_trip_in_config_home(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            home = Path(tmpdir)
            set_result = run_control("settings", "set", "terminal.default_mode", "light", home=home)
            self.assertEqual(set_result.returncode, 0, set_result.stderr)
            get_result = run_control(
                "settings", "get", "terminal.default_mode", "--json", home=home
            )
            self.assertEqual(get_result.returncode, 0, get_result.stderr)
            data = json.loads(get_result.stdout)
            self.assertEqual(data["key"], "terminal.default_mode")
            self.assertEqual(data["value"], "light")

    def test_settings_schema_and_validation_are_machine_readable(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            home = Path(tmpdir)
            schema_result = run_control("settings", "schema", "--json", home=home)
            self.assertEqual(schema_result.returncode, 0, schema_result.stderr)
            schema = json.loads(schema_result.stdout)
            self.assertEqual(schema["schema"], "dreamcoder.settings-schema.v1")
            self.assertEqual(schema["settings"]["terminal.default_mode"]["enum"], ["light", "dark"])

            valid_result = run_control("settings", "validate", "--json", home=home)
            self.assertEqual(valid_result.returncode, 0, valid_result.stderr)
            self.assertTrue(json.loads(valid_result.stdout)["valid"])

    def test_settings_validation_rejects_invalid_known_values(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            home = Path(tmpdir)
            invalid_set = run_control(
                "settings", "set", "terminal.default_mode", "neon", "--json", home=home
            )
            self.assertEqual(invalid_set.returncode, 2)
            self.assertIn("terminal.default_mode must be one of", invalid_set.stderr)

            settings = home / ".config" / "dreamcoder" / "settings.json"
            settings.parent.mkdir(parents=True)
            settings.write_text(json.dumps({"terminal": {"default_mode": "neon"}}))
            validate = run_control("settings", "validate", "--json", home=home)
            self.assertEqual(validate.returncode, 1)
            data = json.loads(validate.stdout)
            self.assertFalse(data["valid"])
            self.assertEqual(data["errors"][0]["key"], "terminal.default_mode")

    def test_doctor_json_has_actionable_checks(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            home = Path(tmpdir)
            result = run_control("doctor", "--json", home=home)
            self.assertEqual(result.returncode, 0, result.stderr)
            data = json.loads(result.stdout)
            self.assertEqual(data["schema"], "dreamcoder.doctor.v1")
            self.assertGreaterEqual(len(data["checks"]), 6)
            for check in data["checks"]:
                self.assertIn(check["status"], {"ok", "warn", "fail", "skip"})
                self.assertIn("repair", check)

    def test_dashboard_json_summarizes_control_center_state(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            home = Path(tmpdir)
            (home / ".config" / "dreamcoder").mkdir(parents=True)
            (home / ".config" / "dreamcoder" / "settings.json").write_text(
                json.dumps(
                    {
                        "profile": {"active": "asus-vivobook15"},
                        "motion": {"active": "fluid"},
                    }
                )
            )
            kitty_colors = home / ".config" / "kitty" / "colors-dreamcoder.conf"
            kitty_colors.parent.mkdir(parents=True)
            kitty_colors.write_text("# Dreamcoder Light\n")

            result = run_control("dashboard", "--json", home=home)
            self.assertEqual(result.returncode, 0, result.stderr)
            data = json.loads(result.stdout)
            self.assertEqual(data["schema"], "dreamcoder.dashboard.v1")
            self.assertEqual(data["state"]["profile"], "asus-vivobook15")
            self.assertEqual(data["state"]["motion"], "fluid")
            self.assertEqual(data["state"]["theme_mode"], "light")
            self.assertIn("doctor", data["commands"])
            self.assertIn("health", data)
            self.assertIn("installer", data)

    def test_dashboard_markdown_is_visual_operator_summary(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            home = Path(tmpdir)
            result = run_control("dashboard", "--markdown", home=home)
            self.assertEqual(result.returncode, 0, result.stderr)
            self.assertIn("# Dreamcoder Control Center", result.stdout)
            self.assertIn("## Current State", result.stdout)
            self.assertIn("## Operator Commands", result.stdout)

    def test_repair_plan_exposes_safe_actions_from_doctor(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            home = Path(tmpdir)
            kitty_ui = home / ".config" / "kitty" / "dreamcoder-ui.conf"
            kitty_ui.parent.mkdir(parents=True)
            kitty_ui.write_text("cursor_trail          1\ninclude colors-dreamcoder.conf\n")

            result = run_control("repair", "plan", "--json", home=home)
            self.assertEqual(result.returncode, 0, result.stderr)
            data = json.loads(result.stdout)
            self.assertEqual(data["schema"], "dreamcoder.repair-plan.v1")
            safe_actions = {action["id"]: action for action in data["actions"] if action["safe"]}
            self.assertIn("kitty-remove-duplicate-color-include", safe_actions)
            self.assertEqual(
                safe_actions["kitty-remove-duplicate-color-include"]["target"], str(kitty_ui)
            )

    def test_repair_apply_removes_duplicate_include_with_backup(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            home = Path(tmpdir)
            kitty_ui = home / ".config" / "kitty" / "dreamcoder-ui.conf"
            kitty_ui.parent.mkdir(parents=True)
            kitty_ui.write_text("cursor_trail          1\ninclude colors-dreamcoder.conf\n")

            dry = run_control("repair", "apply", "--dry-run", "--json", home=home)
            self.assertEqual(dry.returncode, 0, dry.stderr)
            self.assertIn("include colors-dreamcoder.conf", kitty_ui.read_text())

            result = run_control("repair", "apply", "--json", home=home)
            self.assertEqual(result.returncode, 0, result.stderr)
            data = json.loads(result.stdout)
            self.assertEqual(data["schema"], "dreamcoder.repair-apply.v1")
            self.assertIn("backup_id", data)
            self.assertNotIn("include colors-dreamcoder.conf", kitty_ui.read_text())
            self.assertTrue(
                (
                    home
                    / ".local"
                    / "share"
                    / "dreamcoder"
                    / "backups"
                    / data["backup_id"]
                    / "manifest.json"
                ).exists()
            )

    def test_profile_apply_writes_state_and_backup_manifest(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            home = Path(tmpdir)
            hypr = home / ".config" / "hypr" / "hyprland.conf"
            hypr.parent.mkdir(parents=True)
            hypr.write_text("input {\n    repeat_rate = 25\n}\n")

            result = run_control("profile", "apply", "asus-vivobook15", "--json", home=home)
            self.assertEqual(result.returncode, 0, result.stderr)
            data = json.loads(result.stdout)
            self.assertFalse(data["dry_run"])
            self.assertIn("backup_id", data)
            self.assertTrue((home / ".config" / "dreamcoder" / "profile.json").exists())
            settings = json.loads((home / ".config" / "dreamcoder" / "settings.json").read_text())
            self.assertEqual(settings["profile"]["active"], "asus-vivobook15")
            self.assertEqual(settings["terminal"]["default_mode"], "light")
            self.assertTrue(
                (
                    home
                    / ".local"
                    / "share"
                    / "dreamcoder"
                    / "backups"
                    / data["backup_id"]
                    / "manifest.json"
                ).exists()
            )

    def test_motion_apply_writes_state_and_can_be_rolled_back(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            home = Path(tmpdir)
            kitty_ui = home / ".config" / "kitty" / "dreamcoder-ui.conf"
            kitty_ui.parent.mkdir(parents=True)
            kitty_ui.write_text("cursor_trail          0\n")

            apply_result = run_control("motion", "apply", "fluid", "--json", home=home)
            self.assertEqual(apply_result.returncode, 0, apply_result.stderr)
            data = json.loads(apply_result.stdout)
            self.assertIn("backup_id", data)
            self.assertEqual(
                json.loads((home / ".config" / "dreamcoder" / "motion.json").read_text())["name"],
                "fluid",
            )
            self.assertIn("cursor_trail          1", kitty_ui.read_text())

            kitty_ui.write_text("broken\n")
            rollback = run_control("backup", "restore", data["backup_id"], "--json", home=home)
            self.assertEqual(rollback.returncode, 0, rollback.stderr)
            self.assertEqual(kitty_ui.read_text(), "cursor_trail          0\n")

    def test_backup_create_and_restore_dry_run_are_manifest_based(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            home = Path(tmpdir)
            sample = home / ".config" / "kitty" / "kitty.conf"
            sample.parent.mkdir(parents=True)
            sample.write_text("original\n")

            created = run_control("backup", "create", str(sample), "--json", home=home)
            self.assertEqual(created.returncode, 0, created.stderr)
            backup_id = json.loads(created.stdout)["backup_id"]
            sample.write_text("changed\n")

            dry = run_control("backup", "restore", backup_id, "--dry-run", "--json", home=home)
            self.assertEqual(dry.returncode, 0, dry.stderr)
            dry_data = json.loads(dry.stdout)
            self.assertTrue(dry_data["dry_run"])
            self.assertEqual(sample.read_text(), "changed\n")
            self.assertIn(str(sample), dry_data["planned_restore"])

    def test_installer_plan_detects_conflicts_before_stow(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            home = Path(tmpdir)
            kitty = home / ".config" / "kitty"
            kitty.mkdir(parents=True)
            (kitty / "foreign.conf").write_text("not dreamcoder\n")

            result = run_control("installer", "plan", "--json", home=home)
            self.assertEqual(result.returncode, 0, result.stderr)
            data = json.loads(result.stdout)
            self.assertEqual(data["schema"], "dreamcoder.install-plan.v1")
            conflicts = {item["path"]: item for item in data["conflicts"]}
            self.assertIn(str(kitty), conflicts)
            self.assertEqual(conflicts[str(kitty)]["status"], "conflict")
            self.assertIn("backup create", data["backup_command"])

    def test_installer_plan_marks_repo_symlinks_as_managed(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            home = Path(tmpdir)
            target = home / ".config" / "kitty"
            target.parent.mkdir(parents=True)
            target.symlink_to(ROOT / "Kitty" / ".config" / "kitty")

            result = run_control("installer", "plan", "--json", home=home)
            self.assertEqual(result.returncode, 0, result.stderr)
            data = json.loads(result.stdout)
            target_rows = {item["path"]: item for item in data["targets"]}
            self.assertEqual(target_rows[str(target)]["status"], "managed")

    def test_installer_plan_marks_repo_symlink_directories_as_managed(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            home = Path(tmpdir)
            target = home / ".local" / "share" / "warp-terminal" / "themes"
            target.mkdir(parents=True)
            (target / "Dreamcoder.yaml").symlink_to(
                ROOT / "Warp" / ".local" / "share" / "warp-terminal" / "themes" / "Dreamcoder.yaml"
            )

            result = run_control("installer", "plan", "--json", home=home)
            self.assertEqual(result.returncode, 0, result.stderr)
            data = json.loads(result.stdout)
            target_rows = {item["path"]: item for item in data["targets"]}
            self.assertEqual(target_rows[str(target)]["status"], "managed")

    def test_install_and_repair_scripts_create_manifest_backups(self):
        install = (ROOT / "scripts" / "install.sh").read_text()
        repair = (ROOT / "scripts" / "repair.sh").read_text()
        maintenance = (ROOT / "scripts" / "dreamcoder-maintenance.sh").read_text()
        library = (ROOT / "scripts" / "dreamcoder-lib.sh").read_text()
        self.assertIn("dreamcoder-maintenance.sh", install)
        self.assertIn("dreamcoder-maintenance.sh", repair)
        self.assertIn("dreamcoder_backup", maintenance)
        self.assertIn("backup create", library)
        self.assertIn("backup restore", maintenance)


if __name__ == "__main__":
    unittest.main()
