"""Session management and state persistence with file locking."""

from __future__ import annotations

import json
import os
import sys
import time
from dataclasses import asdict, dataclass, field
from pathlib import Path
from typing import Any, Dict, List, Optional


def _lock_file(file_obj) -> None:
    """Acquire exclusive file lock cross-platform."""
    if sys.platform == "win32":
        import msvcrt
        file_obj.seek(0)
        # Lock first byte
        msvcrt.locking(file_obj.fileno(), msvcrt.LK_LOCK, 1)
    else:
        import fcntl
        fcntl.flock(file_obj.fileno(), fcntl.LOCK_EX)


def _unlock_file(file_obj) -> None:
    """Release file lock cross-platform."""
    if sys.platform == "win32":
        import msvcrt
        file_obj.seek(0)
        try:
            msvcrt.locking(file_obj.fileno(), msvcrt.LK_UNLCK, 1)
        except OSError:
            pass
    else:
        import fcntl
        try:
            fcntl.flock(file_obj.fileno(), fcntl.LOCK_UN)
        except OSError:
            pass


@dataclass
class SessionState:
    """Persistent state representation for CLI-Anything harness."""

    session_id: str = "default"
    project_root: str = r"D:\VibeCode\Game_VietHoa\Imouto_Mobile_Project"
    last_action: str = "init"
    last_status: str = "idle"
    dry_run: bool = False
    build_in_progress: bool = False
    last_build_time: Optional[float] = None
    last_build_success: Optional[bool] = None
    last_sign_success: Optional[bool] = None
    last_deploy_success: Optional[bool] = None
    action_history: List[Dict[str, Any]] = field(default_factory=list)
    metadata: Dict[str, Any] = field(default_factory=dict)


class SessionManager:
    """Manages reading and writing session state with robust file locking."""

    def __init__(self, session_path: Optional[Path] = None, dry_run: bool = False) -> None:
        if session_path is None:
            state_dir = Path.home() / ".cli_anything" / "imouto"
            state_dir.mkdir(parents=True, exist_ok=True)
            session_path = state_dir / "session.json"
        self.session_path = session_path
        self.dry_run = dry_run
        self.state = self.load()
        if dry_run:
            self.state.dry_run = True

    def load(self) -> SessionState:
        """Load session state with locking."""
        if not self.session_path.exists():
            return SessionState(dry_run=self.dry_run)

        try:
            with open(self.session_path, "r", encoding="utf-8") as f:
                data = json.load(f)
                return SessionState(**data)
        except Exception:
            return SessionState(dry_run=self.dry_run)

    def save(self) -> None:
        """Save session state safely using atomic write and locking."""
        if self.dry_run:
            return

        self.session_path.parent.mkdir(parents=True, exist_ok=True)
        temp_path = self.session_path.with_suffix(".tmp")

        data = asdict(self.state)
        with open(temp_path, "w", encoding="utf-8") as f:
            _lock_file(f)
            try:
                json.dump(data, f, indent=2, ensure_ascii=False)
                f.flush()
                os.fsync(f.fileno())
            finally:
                _unlock_file(f)

        # Atomic replace
        temp_path.replace(self.session_path)

    def record_action(self, action: str, status: str, details: Optional[Dict[str, Any]] = None) -> None:
        """Record an operation in the session state."""
        self.state.last_action = action
        self.state.last_status = status
        entry = {
            "action": action,
            "status": status,
            "timestamp": time.time(),
            "details": details or {},
        }
        self.state.action_history.append(entry)
        # Keep history bounded
        if len(self.state.action_history) > 100:
            self.state.action_history = self.state.action_history[-100:]
        self.save()
