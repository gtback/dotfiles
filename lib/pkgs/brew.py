# SPDX-FileCopyrightText: 2026 Greg Back <git@gregback.net>
# SPDX-License-Identifier: MIT

"""What each Brewfile entry puts on the machine."""

from __future__ import annotations

import json
import re
import subprocess
from pathlib import Path

from .brewfile import Entry
from .usage import Provides

APP_DIRS = [Path("/Applications"), Path.home() / "Applications"]
MAS_LINE = re.compile(r"^\s*(\d+)\s+(.+?)\s+\([^)]*\)\s*$")
MAS_ID = re.compile(r"id:\s*(\d+)")


def _run(*args: str) -> str:
    return subprocess.run(args, capture_output=True, text=True, check=False).stdout


def _prefix() -> Path:
    return Path(_run("brew", "--prefix").strip())


def _find_app(name: str) -> Path:
    """Return the bundle path for `name`, preferring one that exists."""
    for directory in APP_DIRS:
        if (directory / name).exists():
            return directory / name
    return APP_DIRS[0] / name


def _artifact_names(values) -> list[str]:
    """Flatten a cask artifact list, which mixes strings and {'target': ...} dicts."""
    names = []
    for value in values:
        if isinstance(value, dict):
            target = value.get("target")
            if target:
                names.append(target)
        else:
            names.append(value)
    return names


def _cask_provides(tokens: list[str]) -> dict[str, Provides]:
    if not tokens:
        return {}
    info = json.loads(_run("brew", "info", "--json=v2", "--cask", *tokens) or "{}")
    result = {}
    for cask in info.get("casks", []):
        provides = Provides()
        for artifact in cask.get("artifacts", []):
            for kind, values in artifact.items():
                if kind == "app":
                    provides.apps += [
                        _find_app(Path(n).name) for n in _artifact_names(values)
                    ]
                elif kind == "binary":
                    # Prefer the link name ({'target': ...}) over the source path.
                    names = [n for n in _artifact_names(values)]
                    target = next(
                        (
                            v["target"]
                            for v in values
                            if isinstance(v, dict) and "target" in v
                        ),
                        None,
                    )
                    provides.commands += (
                        [Path(target or names[0]).name] if names else []
                    )
        result[cask["token"]] = provides
        result[cask["full_token"]] = provides
    return result


def provides(entries: list[Entry]) -> dict[tuple[str, str], Provides]:
    """Map (decl_type, name) of each brew/cask/mas entry to what it provides."""
    result: dict[tuple[str, str], Provides] = {}

    prefix = _prefix()
    for entry in entries:
        if entry.decl_type != "brew":
            continue
        opt = prefix / "opt" / entry.name
        commands = []
        for sub in ("bin", "sbin"):
            directory = opt / sub
            if directory.is_dir():
                commands += sorted(p.name for p in directory.iterdir())
        result[("brew", entry.name)] = Provides(commands=commands)

    casks = {e.name: e for e in entries if e.decl_type == "cask"}
    cask_info = _cask_provides(
        [f"{e.tap}/{e.name}" if e.tap else e.name for e in casks.values()]
    )
    for name, entry in casks.items():
        full = f"{entry.tap}/{name}" if entry.tap else name
        result[("cask", name)] = cask_info.get(full) or cask_info.get(name, Provides())

    mas_entries = [e for e in entries if e.decl_type == "mas"]
    if mas_entries:
        installed = {}
        for line in _run("mas", "list").splitlines():
            match = MAS_LINE.match(line)
            if match:
                installed[match.group(1)] = match.group(2)
        for entry in mas_entries:
            match = MAS_ID.search(entry.line)
            name = installed.get(match.group(1)) if match else None
            apps = [_find_app(f"{name}.app")] if name else []
            result[("mas", entry.name)] = Provides(apps=apps)

    return result
