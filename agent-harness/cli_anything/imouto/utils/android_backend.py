"""Android device and LDPlayer 9 management backend via ADB and LDConsole."""

from __future__ import annotations

import subprocess
import time
from pathlib import Path
from typing import Any, Dict, List, Optional

from cli_anything.imouto.core.config import ImoutoConfig


class AndroidBackend:
    """Automates emulator lifecycle, ADB connection, APK deployment and test execution."""

    def __init__(self, config: ImoutoConfig) -> None:
        self.config = config

    def _run_adb(self, args: List[str], timeout: int = 60) -> subprocess.CompletedProcess[str]:
        """Run adb command with specified arguments."""
        cmd = [str(self.config.adb_exe)] + args
        return subprocess.run(
            cmd,
            capture_output=True,
            text=True,
            check=False,
            timeout=timeout,
        )

    def list_devices(self) -> List[Dict[str, str]]:
        """List currently connected adb devices."""
        try:
            res = self._run_adb(["devices"])
            devices = []
            for line in res.stdout.strip().splitlines()[1:]:
                parts = line.split()
                if len(parts) >= 2:
                    devices.append({"serial": parts[0], "state": parts[1]})
            return devices
        except Exception:
            return []

    def connect_emulator(self, host: str = "127.0.0.1:5555") -> Dict[str, Any]:
        """Connect ADB to LDPlayer or emulator port."""
        try:
            res = self._run_adb(["connect", host])
            return {
                "success": "connected" in res.stdout or "already" in res.stdout,
                "output": res.stdout.strip(),
            }
        except Exception as e:
            return {"success": False, "error": str(e)}

    def start_emulator(self, index: int = 0) -> Dict[str, Any]:
        """Launch LDPlayer instance using ldconsole.exe."""
        if not self.config.ldconsole.is_file():
            return {"success": False, "error": f"ldconsole not found at: {self.config.ldconsole}"}

        try:
            cmd = [str(self.config.ldconsole), "launch", "--index", str(index)]
            res = subprocess.run(cmd, capture_output=True, text=True, check=False)
            return {"success": res.returncode == 0, "output": res.stdout.strip()}
        except Exception as e:
            return {"success": False, "error": str(e)}

    def stop_emulator(self, index: int = 0) -> Dict[str, Any]:
        """Quit LDPlayer instance using ldconsole.exe."""
        if not self.config.ldconsole.is_file():
            return {"success": False, "error": f"ldconsole not found at: {self.config.ldconsole}"}

        try:
            cmd = [str(self.config.ldconsole), "quit", "--index", str(index)]
            res = subprocess.run(cmd, capture_output=True, text=True, check=False)
            return {"success": res.returncode == 0, "output": res.stdout.strip()}
        except Exception as e:
            return {"success": False, "error": str(e)}

    def install_apk(self, apk_path: Optional[Path] = None, timeout: int = 180) -> Dict[str, Any]:
        """Install APK to connected device."""
        target_apk = apk_path or self.config.signed_apk
        if not target_apk.is_file():
            return {"success": False, "error": f"Target APK not found: {target_apk}"}

        try:
            res = self._run_adb(["install", "-r", str(target_apk)], timeout=timeout)
            success = "Success" in res.stdout
            return {
                "success": success,
                "output": res.stdout.strip(),
                "error": res.stderr.strip() if not success else "",
            }
        except Exception as e:
            return {"success": False, "error": str(e)}

    def launch_app(self) -> Dict[str, Any]:
        """Start main activity of game."""
        component = f"{self.config.package_name}/{self.config.main_activity}"
        try:
            res = self._run_adb(["shell", "am", "start", "-n", component])
            return {
                "success": res.returncode == 0,
                "output": res.stdout.strip(),
            }
        except Exception as e:
            return {"success": False, "error": str(e)}

    def capture_screenshot(self, output_path: Path) -> Dict[str, Any]:
        """Capture screenshot from device and save as PNG."""
        output_path.parent.mkdir(parents=True, exist_ok=True)
        try:
            cmd = [str(self.config.adb_exe), "exec-out", "screencap", "-p"]
            with open(output_path, "wb") as f:
                res = subprocess.run(cmd, stdout=f, check=False)
            success = res.returncode == 0 and output_path.stat().st_size > 0
            return {
                "success": success,
                "screenshot_path": str(output_path),
                "size_bytes": output_path.stat().st_size if success else 0,
            }
        except Exception as e:
            return {"success": False, "error": str(e)}

    def get_logcat(self, filter_text: Optional[str] = None, lines: int = 100) -> List[str]:
        """Dump recent logcat lines optionally filtered by keyword."""
        try:
            res = self._run_adb(["logcat", "-d", "-t", str(lines)])
            all_lines = res.stdout.splitlines()
            if filter_text:
                return [l for l in all_lines if filter_text.lower() in l.lower()]
            return all_lines
        except Exception:
            return []
