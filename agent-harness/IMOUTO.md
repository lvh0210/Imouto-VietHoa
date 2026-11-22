# IMOUTO: Native Android Port & Localization SOP

## Purpose
Standard Operating Procedure for AI agents managing the Unity 2022.3.62f1 Android port and Vietnamese localization of "妹と過ごす1ヵ月間_Re".

## Architecture
- **Engine**: Unity 2022.3.62f1 (IL2CPP ARM64-v8a, OpenGLES3, URP)
- **Live2D Runtime**: Live2D Cubism Core 4.x (`libLive2DCubismCore.so` + `Live2D.Cubism.dll`)
- **VN Scripting**: Naninovel Engine + BehaviorDesigner
- **Localization**: TextMeshPro `RiiPopkaku_VI` font + runtime hook `ImoutoVi.dll`

## CLI Tooling
- Binary: `cli-anything-imouto` or `imouto` (Python package `cli_anything.imouto`)
- Machine-readable mode: `--json` flag on any command.
- Session lock: `~/.cli_anything/imouto/session.json`.

## Common Workflows
1. Health check: `cli-anything-imouto --json status`
2. Sync Live2D native lib: `cli-anything-imouto fix-live2d`
3. Compile Android APK: `cli-anything-imouto build`
4. Sign & deliver APK: `cli-anything-imouto sign`
5. Test on emulator: `cli-anything-imouto deploy && cli-anything-imouto launch`
