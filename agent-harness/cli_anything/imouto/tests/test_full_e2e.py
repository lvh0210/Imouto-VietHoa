"""End-to-End and Subprocess tests for cli-anything-imouto."""

from __future__ import annotations

import json
import shutil
import subprocess
import sys
from pathlib import Path
import pytest


def _resolve_cli() -> list[str]:
    """Find installed CLI executable or fallback to python -m."""
    exe = shutil.which("cli-anything-imouto")
    if exe:
        return [exe]
    return [sys.executable, "-m", "cli_anything.imouto"]


def test_cli_subprocess_version() -> None:
    """Verify CLI binary resolves and runs via subprocess."""
    cmd = _resolve_cli() + ["--version"]
    res = subprocess.run(cmd, capture_output=True, text=True, check=False)
    assert res.returncode == 0
    assert "1.0.0" in res.stdout


def test_cli_subprocess_status_json() -> None:
    """Verify CLI binary status --json execution."""
    cmd = _resolve_cli() + ["--json", "status"]
    res = subprocess.run(cmd, capture_output=True, text=True, check=False)
    assert res.returncode == 0
    data = json.loads(res.stdout)
    assert "paths" in data
    assert "live2d" in data
    assert "builds" in data


def test_cli_subprocess_fix_live2d() -> None:
    """Verify CLI fix-live2d command via subprocess."""
    cmd = _resolve_cli() + ["--json", "fix-live2d"]
    res = subprocess.run(cmd, capture_output=True, text=True, check=False)
    assert res.returncode == 0
    data = json.loads(res.stdout)
    assert data.get("success") is True
