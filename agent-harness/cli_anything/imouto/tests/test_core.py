"""Unit tests for cli_anything.imouto harness."""

from __future__ import annotations

import json
from pathlib import Path
from click.testing import CliRunner
import pytest

from cli_anything.imouto.core.config import ImoutoConfig
from cli_anything.imouto.core.session import SessionManager, SessionState
from cli_anything.imouto.core.project import ProjectInspector
from cli_anything.imouto.imouto_cli import cli


def test_config_defaults() -> None:
    """Verify default configuration resolution."""
    cfg = ImoutoConfig()
    assert cfg.project_root == Path(r"D:\VibeCode\Game_VietHoa\Imouto_Mobile_Project")
    assert cfg.unity_project == cfg.project_root / "ExportedProject"
    assert cfg.package_name == "com.imouto.viethoa"
    assert cfg.signed_apk.name == "Imouto_Native_Signed.apk"


def test_config_validation() -> None:
    """Verify config validation method returns booleans."""
    cfg = ImoutoConfig()
    val = cfg.validate()
    assert isinstance(val, dict)
    assert "project_root" in val
    assert "unity_project" in val
    assert "unity_exe" in val
    assert "apksigner" in val
    assert val["project_root"] is True
    assert val["unity_project"] is True


def test_config_serialization() -> None:
    """Verify serialization to JSON-compatible dictionary."""
    cfg = ImoutoConfig()
    d = cfg.to_dict()
    assert isinstance(d, dict)
    # Check that it serializes to json without error
    s = json.dumps(d)
    assert "project_root" in s
    assert d["package_name"] == "com.imouto.viethoa"


def test_session_manager(tmp_path: Path) -> None:
    """Verify session save, load, and action recording with file locking."""
    session_file = tmp_path / "test_session.json"
    sm = SessionManager(session_path=session_file)
    assert sm.state.last_status == "idle"

    sm.record_action("test_action", "ok", {"detail": 123})
    assert session_file.is_file()

    # Reload in fresh manager
    sm2 = SessionManager(session_path=session_file)
    assert sm2.state.last_action == "test_action"
    assert sm2.state.last_status == "ok"
    assert len(sm2.state.action_history) == 1
    assert sm2.state.action_history[0]["details"]["detail"] == 123


def test_project_inspector() -> None:
    """Verify project inspector methods."""
    cfg = ImoutoConfig()
    inspector = ProjectInspector(cfg)

    live2d_info = inspector.check_live2d()
    assert isinstance(live2d_info, dict)
    assert "lib_primary_present" in live2d_info
    assert "status" in live2d_info

    shader_info = inspector.check_shaders()
    assert isinstance(shader_info, dict)
    assert "total_custom_shaders" in shader_info

    loc_info = inspector.check_localization()
    assert isinstance(loc_info, dict)
    assert "status" in loc_info

    builds_info = inspector.check_builds()
    assert isinstance(builds_info, dict)
    assert "signed_apk" in builds_info


def test_cli_version() -> None:
    """Verify CLI version flag."""
    runner = CliRunner()
    result = runner.invoke(cli, ["--version"])
    assert result.exit_code == 0
    assert "1.0.0" in result.output


def test_cli_status_json() -> None:
    """Verify CLI status command with --json flag."""
    runner = CliRunner()
    result = runner.invoke(cli, ["--json", "status"])
    assert result.exit_code == 0
    data = json.loads(result.output)
    assert "paths" in data
    assert "live2d" in data
    assert "shaders" in data
    assert "localization" in data


def test_cli_dry_run() -> None:
    """Verify CLI dry run mode prevents mutations."""
    runner = CliRunner()
    result = runner.invoke(cli, ["--dry-run", "--json", "build"])
    assert result.exit_code == 0
    data = json.loads(result.output)
    assert data.get("dry_run") is True
