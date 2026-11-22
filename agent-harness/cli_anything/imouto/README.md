# cli-anything-imouto

Agent-native CLI harness for **妹と過ごす1ヵ月間_Re (Imouto Mobile)** Native Android Port and Vietnamese Localization project.

## Features
- **Project Health Diagnostics (`status`)**: Validates Unity Editor, Android SDK, Java, Apksigner, Keystore, shaders, and Live2D assets.
- **Live2D Integrity Management (`check-live2d`, `fix-live2d`)**: Inspects and synchronizes `libLive2DCubismCore.so` into Android JNI libs.
- **Automated Headless Compilation (`build`)**: Runs Unity batchmode `Builder.BuildAndroidAPK` with timeout and log error parsing.
- **Signature & Delivery (`sign`)**: Dual-scheme V1+V2+V3 apksigner signing and signature verification.
- **Android / LDPlayer Automation (`devices`, `connect`, `deploy`, `launch`, `screenshot`, `logcat`)**: Manages device deployment and testing.
- **JSON Output (`--json`)**: Structured output for AI agent consumption.
- **Interactive REPL (`repl`)**: Rich interactive shell powered by `prompt_toolkit`.

## Installation
```bash
cd D:\VibeCode\Game_VietHoa\Imouto_Mobile_Project\agent-harness
pip install -e .
```

## Quick Start
```bash
# Check status in JSON
cli-anything-imouto --json status

# Fix Live2D arm64-v8a library
cli-anything-imouto fix-live2d

# Sign APK
cli-anything-imouto sign
```
