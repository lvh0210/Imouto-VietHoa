---
name: "cli-anything-Imouto-Mobile-Project"
description: "Command-line interface for Imouto - Agent-native CLI harness for **妹と過ごす1ヵ月間_Re (Imouto Mobile)** Native Android Port and Vietnamese Loc..."
---

# cli-anything-Imouto-Mobile-Project

Agent-native CLI harness for **妹と過ごす1ヵ月間_Re (Imouto Mobile)** Native Android Port and Vietnamese Localization project.

## Installation

This CLI is installed as part of the cli-anything-imouto package:

```bash
pip install cli-anything-imouto
```

**Prerequisites:**
- Python 3.10+
- Imouto must be installed on your system

## Usage

### Basic Commands

```bash
# Show help
cli-anything-imouto --help

# Start interactive REPL mode
cli-anything-imouto

# Create a new project
cli-anything-imouto project new -o project.json

# Run with JSON output (for agent consumption)
cli-anything-imouto --json project info -p project.json
```

## Command Groups

### Cli

CLI-Anything Harness for Imouto Mobile Native Android Port & Localization.

| Command | Description |
|---------|-------------|
| `status` | Inspect full project status, toolchain paths, assets, and APK outputs. |
| `check-live2d` | Inspect Live2D native ARM64 libraries, DLLs, and loader scripts. |
| `fix-live2d` | Sync libLive2DCubismCore.so to standard Assets/Plugins/Android/libs/arm64-v8a. |
| `check-shaders` | Inspect project custom shaders for URP and OpenGL ES 3.0 compatibility. |
| `check-localization` | Inspect Vietnamese localization hook and font assets. |
| `build` | Execute Unity batchmode Android IL2CPP build. |
| `sign` | Sign APK with debug keystore (V1+V2+V3 schemes) and verify. |
| `devices` | List attached ADB devices and emulators. |
| `connect` | Connect ADB to LDPlayer or remote emulator. |
| `deploy` | Install signed APK onto connected Android device or emulator. |
| `launch` | Launch installed game activity on device. |
| `screenshot` | Capture a screenshot from device and save as PNG. |
| `logcat` | Dump recent device logcat entries. |
| `repl` | Start interactive REPL session. |

## Examples

### Create a New Project

Create a new imouto project file.

```bash
cli-anything-imouto project new -o myproject.json
# Or with JSON output for programmatic use
cli-anything-imouto --json project new -o myproject.json
```

### Interactive REPL Session

Start an interactive session with undo/redo support.

```bash
cli-anything-imouto
# Enter commands interactively
# Use 'help' to see available commands
# Use 'undo' and 'redo' for history navigation
```

## For AI Agents

When using this CLI programmatically:

1. **Always use `--json` flag** for parseable output
2. **Check return codes** - 0 for success, non-zero for errors
3. **Parse stderr** for error messages on failure
4. **Use absolute paths** for all file operations
5. **Verify outputs exist** after export operations

## Version

1.0.0