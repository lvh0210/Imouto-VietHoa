# Test Plan: cli-anything-imouto

## Scope
Unit and End-to-End verification of the `cli-anything-imouto` harness.

## Test Matrix

### 1. Unit Tests (`test_core.py`)
- `test_config_defaults`: Verify default paths and fallback logic.
- `test_config_validation`: Verify boolean validation dictionary.
- `test_config_serialization`: Verify JSON-serializable `to_dict()`.
- `test_session_locking_and_save`: Verify atomic save and file locking.
- `test_session_history`: Verify bounded action history tracking.
- `test_project_inspector`: Test inspection of Live2D, Shaders, Localization, Builds.
- `test_cli_version`: Test Click CLI `--version` invocation.
- `test_cli_status_json`: Test `status --json` machine output parsing.
- `test_cli_dry_run`: Verify `--dry-run` flag prevents file mutations.

### 2. E2E Tests (`test_full_e2e.py`)
- `test_live2d_fix_e2e`: Test Live2D library copy and existence.
- `test_apk_signature_verification`: Verify existing built APK signatures.
- `test_cli_subprocess_invocation`: Verify `cli-anything-imouto` binary from PATH via subprocess.

## Execution
```bash
pytest agent-harness/cli_anything/imouto/tests -v
```

## Test Results

```text
============================= test session starts =============================
platform win32 -- Python 3.12.10, pytest-9.2.0, pluggy-1.7.0
rootdir: D:\VibeCode\Game_VietHoa\Imouto_Mobile_Project\agent-harness
collected 11 items

cli_anything/imouto/tests/test_core.py::test_config_defaults PASSED           [  9%]
cli_anything/imouto/tests/test_core.py::test_config_validation PASSED         [ 18%]
cli_anything/imouto/tests/test_core.py::test_config_serialization PASSED      [ 27%]
cli_anything/imouto/tests/test_core.py::test_session_manager PASSED           [ 36%]
cli_anything/imouto/tests/test_core.py::test_project_inspector PASSED         [ 45%]
cli_anything/imouto/tests/test_core.py::test_cli_version PASSED               [ 54%]
cli_anything/imouto/tests/test_core.py::test_cli_status_json PASSED          [ 63%]
cli_anything/imouto/tests/test_core.py::test_cli_dry_run PASSED              [ 72%]
cli_anything/imouto/tests/test_full_e2e.py::test_cli_subprocess_version PASSED [ 81%]
cli_anything/imouto/tests/test_full_e2e.py::test_cli_subprocess_status_json PASSED [ 90%]
cli_anything/imouto/tests/test_full_e2e.py::test_cli_subprocess_fix_live2d PASSED [100%]

============================= 11 passed in 1.15s ==============================
```
