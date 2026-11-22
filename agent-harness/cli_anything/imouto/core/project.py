"""Project inspection, asset diagnostics and automated repair routines."""

from __future__ import annotations

import os
import shutil
from pathlib import Path
from typing import Any, Dict, List

from cli_anything.imouto.core.config import ImoutoConfig


class ProjectInspector:
    """Performs deep diagnostics and checks on the Unity project assets and configs."""

    def __init__(self, config: ImoutoConfig) -> None:
        self.config = config
        self.unity_project = config.unity_project
        self.assets_dir = self.unity_project / "Assets"

    def inspect_all(self) -> Dict[str, Any]:
        """Perform comprehensive inspection of all project sub-systems."""
        return {
            "paths": self.config.validate(),
            "live2d": self.check_live2d(),
            "shaders": self.check_shaders(),
            "localization": self.check_localization(),
            "builds": self.check_builds(),
        }

    def check_live2d(self) -> Dict[str, Any]:
        """Inspect Live2D Cubism Core libraries and loader scripts."""
        cubism_so_primary = (
            self.assets_dir
            / "Live2D"
            / "Cubism"
            / "Plugins"
            / "Android"
            / "arm64-v8a"
            / "libLive2DCubismCore.so"
        )
        cubism_so_alt = (
            self.assets_dir
            / "Plugins"
            / "Android"
            / "libs"
            / "arm64-v8a"
            / "libLive2DCubismCore.so"
        )
        cubism_dll = self.assets_dir / "Plugins" / "Live2D.Cubism.dll"
        loader_cs = (
            self.assets_dir
            / "Scripts"
            / "Assembly-CSharp"
            / "Live2DAndroidLoader.cs"
        )

        return {
            "lib_primary_present": cubism_so_primary.is_file(),
            "lib_primary_size": cubism_so_primary.stat().st_size if cubism_so_primary.is_file() else 0,
            "lib_alt_present": cubism_so_alt.is_file(),
            "lib_alt_size": cubism_so_alt.stat().st_size if cubism_so_alt.is_file() else 0,
            "dll_present": cubism_dll.is_file(),
            "loader_cs_present": loader_cs.is_file(),
            "status": "ready" if (cubism_so_primary.is_file() or cubism_so_alt.is_file()) and cubism_dll.is_file() else "missing_core",
        }

    def fix_live2d(self) -> Dict[str, Any]:
        """Ensure libLive2DCubismCore.so is properly positioned without plugin collisions."""
        src_so = (
            self.assets_dir
            / "Live2D"
            / "Cubism"
            / "Plugins"
            / "Android"
            / "arm64-v8a"
            / "libLive2DCubismCore.so"
        )
        colliding_dir = self.assets_dir / "Plugins" / "Android" / "libs" / "arm64-v8a"
        colliding_so = colliding_dir / "libLive2DCubismCore.so"
        colliding_meta = colliding_dir / "libLive2DCubismCore.so.meta"

        actions: List[str] = []
        # If both exist, remove the colliding duplicate in Plugins/Android/libs to avoid Unity build error
        if src_so.is_file() and colliding_so.is_file():
            colliding_so.unlink(missing_ok=True)
            colliding_meta.unlink(missing_ok=True)
            actions.append("Removed duplicate in Plugins/Android/libs to avoid plugin architecture collision")

        if src_so.is_file():
            actions.append(f"Authoritative Live2D Core active at {src_so.relative_to(self.unity_project)}")
        else:
            return {"success": False, "error": "Source libLive2DCubismCore.so not found", "actions": actions}

        return {"success": True, "actions": actions, "target": str(src_so)}

    def check_shaders(self) -> Dict[str, Any]:
        """Inspect project shaders and URP render pipeline setup."""
        shader_dir = self.assets_dir / "Shader"
        shader_files = list(shader_dir.glob("*.shader")) if shader_dir.is_dir() else []

        has_live2d_shader = any("Live2D" in f.name for f in shader_files)
        has_tmp_shader = any("TextMeshPro" in f.name or "TMP" in f.name for f in shader_files)

        return {
            "total_custom_shaders": len(shader_files),
            "has_live2d_shader": has_live2d_shader,
            "has_tmp_shader": has_tmp_shader,
            "status": "ok" if len(shader_files) > 0 else "empty",
        }

    def check_localization(self) -> Dict[str, Any]:
        """Inspect localization hooks and TMPro Vietnamese font assets."""
        imouto_vi_dll = self.assets_dir / "Plugins" / "ImoutoVi.dll"
        font_dir = self.assets_dir / "Fonts"
        font_files = list(font_dir.glob("*.*")) if font_dir.is_dir() else []

        return {
            "imouto_vi_dll_present": imouto_vi_dll.is_file(),
            "fonts_found": len(font_files),
            "status": "ready" if imouto_vi_dll.is_file() else "missing_hook",
        }

    def check_builds(self) -> Dict[str, Any]:
        """Inspect build outputs on disk."""
        unsigned = self.config.unsigned_apk
        signed = self.config.signed_apk
        delivered = self.config.delivered_apk

        return {
            "unsigned_apk": {
                "present": unsigned.is_file(),
                "size_mb": round(unsigned.stat().st_size / (1024 * 1024), 2) if unsigned.is_file() else 0,
            },
            "signed_apk": {
                "present": signed.is_file(),
                "size_mb": round(signed.stat().st_size / (1024 * 1024), 2) if signed.is_file() else 0,
            },
            "delivered_apk": {
                "present": delivered.is_file(),
                "size_mb": round(delivered.stat().st_size / (1024 * 1024), 2) if delivered.is_file() else 0,
            },
        }
