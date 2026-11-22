"""Command Line Interface for Imouto Mobile Unity Android Port & Localization."""

from __future__ import annotations

import json
import sys
from pathlib import Path
from typing import Any, Dict, Optional

import click

from cli_anything.imouto.core.config import ImoutoConfig
from cli_anything.imouto.core.project import ProjectInspector
from cli_anything.imouto.core.session import SessionManager
from cli_anything.imouto.utils.android_backend import AndroidBackend
from cli_anything.imouto.utils.repl_skin import ReplSkin
from cli_anything.imouto.utils.signer_backend import SignerBackend
from cli_anything.imouto.utils.unity_backend import UnityBackend


def _output(data: Any, json_mode: bool, skin: Optional[ReplSkin] = None, message: str = "") -> None:
    """Standardized output handler supporting JSON or formatted human text."""
    if json_mode:
        click.echo(json.dumps(data, indent=2, ensure_ascii=False))
    else:
        if message:
            if skin:
                skin.info(message)
            else:
                click.echo(message)
        if isinstance(data, dict):
            for k, v in data.items():
                click.echo(f"  • {k}: {v}")
        elif isinstance(data, list):
            for item in data:
                click.echo(f"  • {item}")
        else:
            click.echo(str(data))


@click.group(invoke_without_command=True)
@click.option("--json", "json_mode", is_flag=True, help="Output machine-readable JSON.")
@click.option("--project-root", type=click.Path(exists=True, file_okay=False), help="Override project root.")
@click.option("--dry-run", is_flag=True, help="Simulate actions without modifying files or building.")
@click.version_option(version="1.0.0", prog_name="cli-anything-imouto")
@click.pass_context
def cli(ctx: click.Context, json_mode: bool, project_root: Optional[str], dry_run: bool) -> None:
    """CLI-Anything Harness for Imouto Mobile Native Android Port & Localization."""
    ctx.ensure_object(dict)
    cfg = ImoutoConfig()
    if project_root:
        cfg.project_root = Path(project_root)
        cfg.__post_init__()

    session = SessionManager(dry_run=dry_run)
    ctx.obj["config"] = cfg
    ctx.obj["session"] = session
    ctx.obj["json_mode"] = json_mode
    ctx.obj["skin"] = ReplSkin("imouto", version="1.0.0")

    if ctx.invoked_subcommand is None:
        ctx.invoke(repl)


@cli.command("status")
@click.pass_context
def status_cmd(ctx: click.Context) -> None:
    """Inspect full project status, toolchain paths, assets, and APK outputs."""
    cfg: ImoutoConfig = ctx.obj["config"]
    json_mode: bool = ctx.obj["json_mode"]
    skin: ReplSkin = ctx.obj["skin"]

    inspector = ProjectInspector(cfg)
    result = inspector.inspect_all()
    _output(result, json_mode, skin, "Project Inspection Results:")


@cli.command("check-live2d")
@click.pass_context
def check_live2d_cmd(ctx: click.Context) -> None:
    """Inspect Live2D native ARM64 libraries, DLLs, and loader scripts."""
    cfg: ImoutoConfig = ctx.obj["config"]
    json_mode: bool = ctx.obj["json_mode"]
    skin: ReplSkin = ctx.obj["skin"]

    inspector = ProjectInspector(cfg)
    result = inspector.check_live2d()
    _output(result, json_mode, skin, "Live2D Diagnostic Status:")


@cli.command("fix-live2d")
@click.pass_context
def fix_live2d_cmd(ctx: click.Context) -> None:
    """Sync libLive2DCubismCore.so to standard Assets/Plugins/Android/libs/arm64-v8a."""
    cfg: ImoutoConfig = ctx.obj["config"]
    session: SessionManager = ctx.obj["session"]
    json_mode: bool = ctx.obj["json_mode"]
    skin: ReplSkin = ctx.obj["skin"]

    inspector = ProjectInspector(cfg)
    result = inspector.fix_live2d()
    session.record_action("fix-live2d", "success" if result.get("success") else "failed", result)
    _output(result, json_mode, skin, "Live2D Fix Action:")


@cli.command("check-shaders")
@click.pass_context
def check_shaders_cmd(ctx: click.Context) -> None:
    """Inspect project custom shaders for URP and OpenGL ES 3.0 compatibility."""
    cfg: ImoutoConfig = ctx.obj["config"]
    json_mode: bool = ctx.obj["json_mode"]
    skin: ReplSkin = ctx.obj["skin"]

    inspector = ProjectInspector(cfg)
    result = inspector.check_shaders()
    _output(result, json_mode, skin, "Shader Diagnostics:")


@cli.command("check-localization")
@click.pass_context
def check_localization_cmd(ctx: click.Context) -> None:
    """Inspect Vietnamese localization hook and font assets."""
    cfg: ImoutoConfig = ctx.obj["config"]
    json_mode: bool = ctx.obj["json_mode"]
    skin: ReplSkin = ctx.obj["skin"]

    inspector = ProjectInspector(cfg)
    result = inspector.check_localization()
    _output(result, json_mode, skin, "Localization Status:")


@cli.command("build")
@click.option("--timeout", type=int, default=1800, help="Build timeout in seconds.")
@click.pass_context
def build_cmd(ctx: click.Context, timeout: int) -> None:
    """Execute Unity batchmode Android IL2CPP build."""
    cfg: ImoutoConfig = ctx.obj["config"]
    session: SessionManager = ctx.obj["session"]
    json_mode: bool = ctx.obj["json_mode"]
    skin: ReplSkin = ctx.obj["skin"]

    if session.dry_run:
        _output({"dry_run": True, "action": "build_apk"}, json_mode, skin, "[DRY-RUN] Unity build simulated.")
        return

    unity = UnityBackend(cfg)
    if not json_mode:
        skin.info(f"Starting Unity Android Build with {cfg.unity_exe.name}...")
    result = unity.build_apk(timeout_seconds=timeout)
    session.record_action("build", "success" if result.get("success") else "failed", result)
    _output(result, json_mode, skin, "Unity Build Result:")


@cli.command("sign")
@click.option("--no-copy", is_flag=True, help="Do not copy signed APK to Downloads.")
@click.pass_context
def sign_cmd(ctx: click.Context, no_copy: bool) -> None:
    """Sign APK with debug keystore (V1+V2+V3 schemes) and verify."""
    cfg: ImoutoConfig = ctx.obj["config"]
    session: SessionManager = ctx.obj["session"]
    json_mode: bool = ctx.obj["json_mode"]
    skin: ReplSkin = ctx.obj["skin"]

    if session.dry_run:
        _output({"dry_run": True, "action": "sign_apk"}, json_mode, skin, "[DRY-RUN] APK sign simulated.")
        return

    signer = SignerBackend(cfg)
    result = signer.sign_apk(copy_to_downloads=not no_copy)
    session.record_action("sign", "success" if result.get("success") else "failed", result)
    _output(result, json_mode, skin, "APK Signing Result:")


@cli.command("devices")
@click.pass_context
def devices_cmd(ctx: click.Context) -> None:
    """List attached ADB devices and emulators."""
    cfg: ImoutoConfig = ctx.obj["config"]
    json_mode: bool = ctx.obj["json_mode"]
    skin: ReplSkin = ctx.obj["skin"]

    android = AndroidBackend(cfg)
    devices = android.list_devices()
    _output(devices, json_mode, skin, "Attached Devices:")


@cli.command("connect")
@click.option("--host", default="127.0.0.1:5555", help="Host/port to connect via ADB.")
@click.pass_context
def connect_cmd(ctx: click.Context, host: str) -> None:
    """Connect ADB to LDPlayer or remote emulator."""
    cfg: ImoutoConfig = ctx.obj["config"]
    json_mode: bool = ctx.obj["json_mode"]
    skin: ReplSkin = ctx.obj["skin"]

    android = AndroidBackend(cfg)
    result = android.connect_emulator(host)
    _output(result, json_mode, skin, f"ADB Connect {host}:")


@cli.command("deploy")
@click.pass_context
def deploy_cmd(ctx: click.Context) -> None:
    """Install signed APK onto connected Android device or emulator."""
    cfg: ImoutoConfig = ctx.obj["config"]
    session: SessionManager = ctx.obj["session"]
    json_mode: bool = ctx.obj["json_mode"]
    skin: ReplSkin = ctx.obj["skin"]

    if session.dry_run:
        _output({"dry_run": True, "action": "deploy_apk"}, json_mode, skin, "[DRY-RUN] Deploy simulated.")
        return

    android = AndroidBackend(cfg)
    result = android.install_apk()
    session.record_action("deploy", "success" if result.get("success") else "failed", result)
    _output(result, json_mode, skin, "APK Deployment Result:")


@cli.command("launch")
@click.pass_context
def launch_cmd(ctx: click.Context) -> None:
    """Launch installed game activity on device."""
    cfg: ImoutoConfig = ctx.obj["config"]
    session: SessionManager = ctx.obj["session"]
    json_mode: bool = ctx.obj["json_mode"]
    skin: ReplSkin = ctx.obj["skin"]

    android = AndroidBackend(cfg)
    result = android.launch_app()
    session.record_action("launch", "success" if result.get("success") else "failed", result)
    _output(result, json_mode, skin, "Launch Application Result:")


@cli.command("screenshot")
@click.argument("output_file", type=click.Path(dir_okay=False))
@click.pass_context
def screenshot_cmd(ctx: click.Context, output_file: str) -> None:
    """Capture a screenshot from device and save as PNG."""
    cfg: ImoutoConfig = ctx.obj["config"]
    json_mode: bool = ctx.obj["json_mode"]
    skin: ReplSkin = ctx.obj["skin"]

    android = AndroidBackend(cfg)
    out_path = Path(output_file)
    result = android.capture_screenshot(out_path)
    _output(result, json_mode, skin, f"Screenshot Captured:")


@cli.command("logcat")
@click.option("--filter", "filter_text", default=None, help="Filter keyword.")
@click.option("--lines", default=50, type=int, help="Number of lines to read.")
@click.pass_context
def logcat_cmd(ctx: click.Context, filter_text: Optional[str], lines: int) -> None:
    """Dump recent device logcat entries."""
    cfg: ImoutoConfig = ctx.obj["config"]
    json_mode: bool = ctx.obj["json_mode"]
    skin: ReplSkin = ctx.obj["skin"]

    android = AndroidBackend(cfg)
    entries = android.get_logcat(filter_text=filter_text, lines=lines)
    _output(entries, json_mode, skin, f"Logcat Output (lines={len(entries)}):")


@cli.command("repl")
@click.pass_context
def repl(ctx: click.Context) -> None:
    """Start interactive REPL session."""
    skin: ReplSkin = ctx.obj["skin"]
    skin.print_banner()
    pt_session = skin.create_prompt_session()

    commands = {
        "status": "Check full project and toolchain health",
        "check-live2d": "Diagnose Live2D assets and loader",
        "fix-live2d": "Sync Live2D .so to standard Android libs",
        "check-shaders": "Diagnose project shaders",
        "check-localization": "Check Vietnamese font and hooks",
        "build": "Run Unity batchmode build",
        "sign": "Sign APK with apksigner",
        "devices": "List ADB devices",
        "connect": "Connect to LDPlayer 127.0.0.1:5555",
        "deploy": "Install APK to device",
        "launch": "Launch game on device",
        "screenshot <file.png>": "Take screenshot from device",
        "logcat [filter]": "View recent logcat logs",
        "help": "Show available commands",
        "exit / quit": "Exit REPL",
    }

    while True:
        try:
            line = skin.get_input(pt_session, project_name="imouto")
            if not line:
                continue
            line = line.strip()
            if line in ("exit", "quit", "q"):
                skin.print_goodbye()
                break
            if line == "help":
                skin.help(commands)
                continue

            parts = line.split()
            cmd_name = parts[0]
            args = parts[1:]

            if cmd_name in cli.commands:
                try:
                    cli.main(args=[cmd_name] + args, standalone_mode=False)
                except Exception as e:
                    skin.error(f"Command error: {e}")
            else:
                skin.warning(f"Unknown command '{cmd_name}'. Type 'help' for available commands.")
        except (KeyboardInterrupt, EOFError):
            skin.print_goodbye()
            break


def main() -> None:
    """Main entrypoint function."""
    cli(obj={})


if __name__ == "__main__":
    main()
