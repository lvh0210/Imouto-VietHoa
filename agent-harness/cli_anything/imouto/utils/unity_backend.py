"""Unity Editor batchmode execution backend."""

from __future__ import annotations

import os
import subprocess
import time
from pathlib import Path
from typing import Any, Dict, List, Optional

from cli_anything.imouto.core.config import ImoutoConfig


class UnityBackend:
    """Controls headless batchmode compilation and log analysis for Unity."""

    def __init__(self, config: ImoutoConfig) -> None:
        self.config = config

    def build_apk(
        self,
        method_name: str = "Builder.BuildAndroidAPK",
        log_file: Optional[Path] = None,
        timeout_seconds: int = 1800,
    ) -> Dict[str, Any]:
        """Execute Unity batchmode build for Android APK."""
        if not self.config.unity_exe.is_file():
            return {
                "success": False,
                "error": f"Unity executable not found at: {self.config.unity_exe}",
                "exit_code": -1,
            }

        if not self.config.unity_project.is_dir():
            return {
                "success": False,
                "error": f"Unity project directory not found at: {self.config.unity_project}",
                "exit_code": -1,
            }

        if log_file is None:
            log_file = self.config.project_root / "build_rebuild.log"

        cmd = [
            str(self.config.unity_exe),
            "-batchmode",
            "-quit",
            "-projectPath",
            str(self.config.unity_project),
            "-executeMethod",
            method_name,
            "-logFile",
            str(log_file),
        ]

        start_time = time.time()
        try:
            proc = subprocess.Popen(
                cmd,
                stdout=subprocess.PIPE,
                stderr=subprocess.PIPE,
                text=True,
            )
            stdout, stderr = proc.communicate(timeout=timeout_seconds)
            exit_code = proc.returncode
        except subprocess.TimeoutExpired:
            proc.kill()
            return {
                "success": False,
                "error": f"Build timed out after {timeout_seconds} seconds",
                "exit_code": -2,
                "duration_seconds": round(time.time() - start_time, 2),
            }
        except Exception as e:
            return {
                "success": False,
                "error": str(e),
                "exit_code": -3,
                "duration_seconds": round(time.time() - start_time, 2),
            }

        duration = round(time.time() - start_time, 2)
        errors, warnings = self._parse_log(log_file)
        success = exit_code == 0 and self.config.unsigned_apk.is_file()

        return {
            "success": success,
            "exit_code": exit_code,
            "duration_seconds": duration,
            "log_file": str(log_file),
            "unsigned_apk": str(self.config.unsigned_apk),
            "errors": errors[:10],
            "warnings_count": len(warnings),
        }

    def _parse_log(self, log_path: Path) -> tuple[List[str], List[str]]:
        """Extract compilation errors and critical warnings from Unity build log."""
        if not log_path.is_file():
            return [], []

        errors: List[str] = []
        warnings: List[str] = []

        try:
            with open(log_path, "r", encoding="utf-8", errors="replace") as f:
                for line in f:
                    line_strip = line.strip()
                    if "error CS" in line_strip or ": error" in line_strip:
                        errors.append(line_strip)
                    elif "warning CS" in line_strip:
                        warnings.append(line_strip)
        except Exception:
            pass

        return errors, warnings
