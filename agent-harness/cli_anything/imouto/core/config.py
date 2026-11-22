"""Configuration management for cli_anything.imouto harness."""

from __future__ import annotations

import os
import shutil
from dataclasses import dataclass, field
from pathlib import Path
from typing import Any, Dict


@dataclass
class ImoutoConfig:
    """Holds all path and execution configuration for the project."""

    project_root: Path = field(
        default_factory=lambda: Path(
            os.environ.get(
                "IMOUTO_PROJECT_ROOT",
                r"D:\VibeCode\Game_VietHoa\Imouto_Mobile_Project",
            )
        )
    )
    unity_project: Path = field(default=Path())
    unity_exe: Path = field(
        default_factory=lambda: Path(
            os.environ.get(
                "UNITY_EXE",
                r"D:\Unity\Editor\2022.3.62f1\Editor\Unity.exe",
            )
        )
    )
    java_home: Path = field(
        default_factory=lambda: Path(
            os.environ.get(
                "JAVA_HOME",
                r"D:\Unity\Editor\2022.3.62f1\Editor\Data\PlaybackEngines\AndroidPlayer\OpenJDK",
            )
        )
    )
    apksigner: Path = field(
        default_factory=lambda: Path(
            r"D:\Unity\Editor\2022.3.62f1\Editor\Data\PlaybackEngines\AndroidPlayer\SDK\build-tools\34.0.0\apksigner.bat"
        )
    )
    keystore: Path = field(
        default_factory=lambda: Path(
            os.environ.get(
                "KEYSTORE_PATH",
                os.path.expanduser(r"~/.android/debug.keystore"),
            )
        )
    )
    keystore_pass: str = "android"
    build_output: Path = field(default=Path())
    unsigned_apk: Path = field(default=Path())
    signed_apk: Path = field(default=Path())
    delivered_apk: Path = field(default=Path(r"D:\Downloads\Imouto_Native_Android.apk"))
    ldplayer_dir: Path = field(default=Path(r"D:\LDPlayer\LDPlayer9"))
    ldconsole: Path = field(default=Path())
    adb_exe: Path = field(default=Path())
    package_name: str = "com.imouto.viethoa"
    main_activity: str = "com.unity3d.player.UnityPlayerActivity"

    def __post_init__(self) -> None:
        """Resolve dependent default paths."""
        if self.unity_project == Path():
            self.unity_project = self.project_root / "ExportedProject"
        if self.build_output == Path():
            self.build_output = self.project_root / "BuildOutput"
        if self.unsigned_apk == Path():
            self.unsigned_apk = self.build_output / "Imouto_Native_Unsigned.apk"
        if self.signed_apk == Path():
            self.signed_apk = self.build_output / "Imouto_Native_Signed.apk"
        if self.ldconsole == Path():
            self.ldconsole = self.ldplayer_dir / "ldconsole.exe"
        if self.adb_exe == Path():
            ld_adb = self.ldplayer_dir / "adb.exe"
            if ld_adb.is_file():
                self.adb_exe = ld_adb
            else:
                sys_adb = shutil.which("adb")
                self.adb_exe = Path(sys_adb) if sys_adb else ld_adb

    def validate(self) -> Dict[str, bool]:
        """Validate existence of all required paths."""
        return {
            "project_root": self.project_root.is_dir(),
            "unity_project": self.unity_project.is_dir(),
            "unity_exe": self.unity_exe.is_file(),
            "java_home": self.java_home.is_dir(),
            "apksigner": self.apksigner.is_file(),
            "keystore": self.keystore.is_file(),
            "ldplayer_dir": self.ldplayer_dir.is_dir(),
            "ldconsole": self.ldconsole.is_file(),
            "adb_exe": self.adb_exe.is_file(),
            "signed_apk_present": self.signed_apk.is_file(),
            "delivered_apk_present": self.delivered_apk.is_file(),
        }

    def to_dict(self) -> Dict[str, Any]:
        """Serialize configuration to dictionary."""
        return {
            "project_root": str(self.project_root),
            "unity_project": str(self.unity_project),
            "unity_exe": str(self.unity_exe),
            "java_home": str(self.java_home),
            "apksigner": str(self.apksigner),
            "keystore": str(self.keystore),
            "keystore_pass": "***",
            "build_output": str(self.build_output),
            "unsigned_apk": str(self.unsigned_apk),
            "signed_apk": str(self.signed_apk),
            "delivered_apk": str(self.delivered_apk),
            "ldplayer_dir": str(self.ldplayer_dir),
            "ldconsole": str(self.ldconsole),
            "adb_exe": str(self.adb_exe),
            "package_name": self.package_name,
            "main_activity": self.main_activity,
            "validation": self.validate(),
        }

    @classmethod
    def get_default_config(cls) -> ImoutoConfig:
        """Create and return a default configuration instance."""
        return cls()
