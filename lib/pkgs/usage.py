# SPDX-FileCopyrightText: 2026 Greg Back <git@gregback.net>
# SPDX-License-Identifier: MIT

"""Evidence of use for installed packages, independent of the package manager.

A package manager module (e.g. `pkgs.brew`) turns its entries into `Provides`: the
command names and app bundles a package puts on the machine. This module knows how
often those commands show up in shell history and when apps were last opened.
"""

from __future__ import annotations

import shlex
import sqlite3
import subprocess
from dataclasses import dataclass, field
from datetime import datetime
from pathlib import Path

MCFLY_DB = Path.home() / "Library/Application Support/mcfly/history.db"


@dataclass
class Provides:
    commands: list[str] = field(default_factory=list)
    apps: list[Path] = field(default_factory=list)


@dataclass
class Usage:
    count_in_window: int = 0
    count_total: int = 0
    last_used: datetime | None = None


def tokens(cmd: str) -> set[str]:
    """Return the set of word tokens in a shell command, reduced to basenames.

    Splitting on shell punctuation means pipelines, `$(...)`, `sudo X`, `xargs X` and
    `find -exec X` all surface X as its own token. A bare argument with the same name as
    a tool also counts; that errs toward keeping a tool, which is the safe direction.
    """
    lexer = shlex.shlex(cmd, posix=True, punctuation_chars=True)
    lexer.whitespace_split = True
    try:
        words = list(lexer)
    except ValueError:  # unbalanced quotes
        words = cmd.split()
    found = set()
    for word in words:
        word = word.lstrip("$(`").rstrip("`)")
        if word:
            found.add(word.rsplit("/", 1)[-1])
    return found


def alias_targets(name: str, aliases: dict[str, str]) -> set[str]:
    """Return every command `name` expands to, following alias chains.

    `gst` -> `git status` and `git` -> `hub` gives {"git", "hub"}. Cycles such as
    `alias git=hub` with `alias hub=git` terminate once a name repeats.
    """
    seen: set[str] = set()
    todo = [name]
    while todo:
        current = todo.pop()
        expansion = aliases.get(current)
        if not expansion:
            continue
        words = tokens_in_order(expansion)
        if not words:
            continue
        target = words[0]
        if target not in seen:
            seen.add(target)
            todo.append(target)
    seen.discard(name)
    return seen


def tokens_in_order(cmd: str) -> list[str]:
    try:
        return shlex.split(cmd)
    except ValueError:
        return cmd.split()


def command_usage(
    since: datetime,
    aliases: dict[str, str] | None = None,
    db: Path = MCFLY_DB,
) -> dict[str, Usage]:
    """Count, per command name, how many history entries invoke it.

    Each history row is one invocation (mcfly doesn't dedup). A name counts once per
    row, and an alias use is also credited to what it expands to.
    """
    aliases = aliases or {}
    cutoff = int(since.timestamp())
    conn = sqlite3.connect(f"file:{db}?mode=ro", uri=True)
    try:
        rows = conn.execute(
            "SELECT cmd, COUNT(*), SUM(when_run >= ?), MAX(when_run) "
            "FROM commands GROUP BY cmd",
            (cutoff,),
        ).fetchall()
    finally:
        conn.close()

    result: dict[str, Usage] = {}
    for cmd, total, in_window, last in rows:
        names = tokens(cmd)
        for name in list(names):
            names |= alias_targets(name, aliases)
        when = datetime.fromtimestamp(last)
        for name in names:
            usage = result.setdefault(name, Usage())
            usage.count_total += total
            usage.count_in_window += in_window
            if usage.last_used is None or when > usage.last_used:
                usage.last_used = when
    return result


def aliases() -> dict[str, str]:
    """Return the aliases of an interactive zsh (aliases, darwin aliases, sh/local)."""
    out = subprocess.run(
        ["zsh", "-ic", "alias"], capture_output=True, text=True, check=False
    ).stdout
    result = {}
    for line in out.splitlines():
        name, sep, value = line.partition("=")
        if not sep:
            continue
        # zsh quotes values containing spaces; unquote to get the expansion.
        words = tokens_in_order(value)
        result[name] = words[0] if words else ""
    return result


def app_last_opened(path: Path) -> datetime | None:
    """Return Spotlight's last-used date for an app bundle, or None if never opened."""
    if not path.exists():
        return None
    out = subprocess.run(
        ["mdls", "-raw", "-name", "kMDItemLastUsedDate", str(path)],
        capture_output=True,
        text=True,
        check=False,
    ).stdout.strip()
    if not out or out == "(null)":
        return None
    return (
        datetime.strptime(out, "%Y-%m-%d %H:%M:%S %z").astimezone().replace(tzinfo=None)
    )
