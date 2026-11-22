"""APK signing and signature verification backend."""

from __future__ import annotations

import os
import shutil
import subprocess
from pathlib import Path
from typing import Any, Dict, Optional

from cli_anything.imouto.core.config import ImoutoConfig


class SignerBackend:
    """Automates APK signing with apksigner, scheme v1/v2/v3 verification, and export."""

    def __init__(self, config: ImoutoConfig) -> None:
        self.config = config

    def sign_apk(
        self,
        input_apk: Optional[Path] = None,
        output_apk: Optional[Path] = None,
        copy_to_downloads: bool = True,
    ) -> Dict[str, Any]:
        """Sign APK using debug keystore with v1, v2, and v3 schemes."""
        in_apk = input_apk or self.config.unsigned_apk
        out_apk = output_apk or self.config.signed_apk

        if not in_apk.is_file():
            return {
                "success": False,
                "error": f"Input APK not found: {in_apk}",
            }

        if not self.config.apksigner.is_file():
            return {
                "success": False,
                "error": f"apksigner not found at: {self.config.apksigner}",
            }

        if not self.config.keystore.is_file():
            return {
                "success": False,
                "error": f"Keystore file not found at: {self.config.keystore}",
            }

        env = os.environ.copy()
        if self.config.java_home.is_dir():
            env["JAVA_HOME"] = str(self.config.java_home)
            env["PATH"] = f"{self.config.java_home / 'bin'};{env.get('PATH', '')}"

        cmd = [
            str(self.config.apksigner),
            "sign",
            "--ks",
            str(self.config.keystore),
            "--ks-pass",
            f"pass:{self.config.keystore_pass}",
            "--v1-signing-enabled",
            "true",
            "--v2-signing-enabled",
            "true",
            "--v3-signing-enabled",
            "true",
            "--out",
            str(out_apk),
            str(in_apk),
        ]

        try:
            res = subprocess.run(
                cmd,
                capture_output=True,
                text=True,
                check=False,
                env=env,
            )
            if res.returncode != 0:
                return {
                    "success": False,
                    "error": f"apksigner failed: {res.stderr or res.stdout}",
                    "returncode": res.returncode,
                }
        except Exception as e:
            return {"success": False, "error": str(e)}

        # Verify signature
        verify_res = self.verify_apk(out_apk)
        if not verify_res.get("verified", False):
            return {
                "success": False,
                "error": f"APK signature verification failed: {verify_res.get('output')}",
                "verify_details": verify_res,
            }

        # Copy to delivery path if requested
        delivered_path = None
        if copy_to_downloads:
            try:
                self.config.delivered_apk.parent.mkdir(parents=True, exist_ok=True)
                shutil.copy2(out_apk, self.config.delivered_apk)
                delivered_path = str(self.config.delivered_apk)
            except Exception as e:
                return {
                    "success": True,
                    "signed_apk": str(out_apk),
                    "verified": True,
                    "delivery_warning": f"Failed to copy to {self.config.delivered_apk}: {e}",
                }

        return {
            "success": True,
            "signed_apk": str(out_apk),
            "verified": True,
            "delivered_apk": delivered_path,
        }

    def verify_apk(self, apk_path: Path) -> Dict[str, Any]:
        """Verify signature scheme compliance of APK."""
        if not apk_path.is_file():
            return {"verified": False, "error": f"File not found: {apk_path}"}

        env = os.environ.copy()
        if self.config.java_home.is_dir():
            env["JAVA_HOME"] = str(self.config.java_home)
            env["PATH"] = f"{self.config.java_home / 'bin'};{env.get('PATH', '')}"

        cmd = [str(self.config.apksigner), "verify", "-v", str(apk_path)]
        try:
            res = subprocess.run(
                cmd,
                capture_output=True,
                text=True,
                check=False,
                env=env,
            )
            verified = res.returncode == 0 and "Verifies" in res.stdout
            return {
                "verified": verified,
                "returncode": res.returncode,
                "output": res.stdout,
                "error": res.stderr if res.returncode != 0 else "",
            }
        except Exception as e:
            return {"verified": False, "error": str(e)}
