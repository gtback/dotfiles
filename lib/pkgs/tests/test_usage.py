# SPDX-FileCopyrightText: 2026 Greg Back <git@gregback.net>
# SPDX-License-Identifier: MIT

import sqlite3
import tempfile
import unittest
from datetime import datetime, timedelta
from pathlib import Path

from pkgs import usage

SCHEMA = """CREATE TABLE commands(
    id INTEGER PRIMARY KEY AUTOINCREMENT, cmd TEXT NOT NULL, cmd_tpl TEXT,
    session_id TEXT NOT NULL, when_run INTEGER NOT NULL, exit_code INTEGER NOT NULL,
    selected INTEGER NOT NULL, dir TEXT, old_dir TEXT)"""


class TokensTest(unittest.TestCase):
    def test_pipelines(self):
        self.assertIn("sd", usage.tokens("cat x | sd a b"))
        self.assertIn("sd", usage.tokens("cat x|sd a b"))

    def test_wrappers_and_substitution(self):
        self.assertIn("sd", usage.tokens("sudo sd a b"))
        self.assertIn("sd", usage.tokens("ls | xargs sd a b"))
        self.assertIn("sd", usage.tokens("find . -exec sd a b {} +"))
        self.assertIn("sd", usage.tokens("echo $(sd a b)"))
        self.assertIn("sd", usage.tokens("echo `sd a b`"))

    def test_full_path(self):
        self.assertIn("rg", usage.tokens("/opt/homebrew/bin/rg foo"))

    def test_no_substring_matches(self):
        self.assertNotIn("sd", usage.tokens("sdk install java"))
        self.assertNotIn("dot", usage.tokens("cd dotfiles"))

    def test_unbalanced_quotes_fall_back(self):
        self.assertIn("sd", usage.tokens("echo 'oops | sd"))


class AliasTest(unittest.TestCase):
    def test_chain(self):
        aliases = {"gst": "git status", "git": "hub"}
        self.assertEqual(usage.alias_targets("gst", aliases), {"git", "hub"})

    def test_cycle_terminates(self):
        aliases = {"git": "hub", "hub": "git"}
        self.assertEqual(usage.alias_targets("git", aliases), {"hub"})

    def test_self_reference(self):
        self.assertEqual(usage.alias_targets("git", {"git": "git"}), set())


class CommandUsageTest(unittest.TestCase):
    def setUp(self):
        tmp = tempfile.TemporaryDirectory()
        self.addCleanup(tmp.cleanup)
        self.db = Path(tmp.name) / "history.db"
        self.now = datetime.now()
        conn = sqlite3.connect(self.db)
        conn.execute(SCHEMA)
        self.conn = conn

    def add(self, cmd: str, days_ago: int, times: int = 1):
        when = int((self.now - timedelta(days=days_ago)).timestamp())
        for _ in range(times):
            self.conn.execute(
                "INSERT INTO commands (cmd, session_id, when_run, exit_code, selected)"
                " VALUES (?, 's', ?, 0, 0)",
                (cmd, when),
            )
        self.conn.commit()

    def usage(self, aliases=None):
        since = self.now - timedelta(days=365)
        return usage.command_usage(since, aliases, db=self.db)

    def test_window_vs_total(self):
        self.add("sd a b", days_ago=10, times=2)
        self.add("sd a b", days_ago=800)
        result = self.usage()["sd"]
        self.assertEqual(result.count_in_window, 2)
        self.assertEqual(result.count_total, 3)
        self.assertLess(self.now - result.last_used, timedelta(days=11))

    def test_one_count_per_command(self):
        self.add("sd a | sd b", days_ago=1)
        self.assertEqual(self.usage()["sd"].count_total, 1)

    def test_alias_credits_targets(self):
        self.add("gst", days_ago=1, times=3)
        result = self.usage({"gst": "git status", "git": "hub"})
        self.assertEqual(result["git"].count_total, 3)
        self.assertEqual(result["hub"].count_total, 3)


if __name__ == "__main__":
    unittest.main()
