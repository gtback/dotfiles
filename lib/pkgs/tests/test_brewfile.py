# SPDX-FileCopyrightText: 2026 Greg Back <git@gregback.net>
# SPDX-License-Identifier: MIT

import tempfile
import unittest
from pathlib import Path

from pkgs import brewfile


def write(root: Path, name: str, text: str) -> Path:
    path = root / name
    path.write_text(text)
    return path


def compile_lines(root: Path, name: str = "Brewfile") -> list:
    return [e.line for e in brewfile.compile(root / name)]


class CompileTest(unittest.TestCase):
    def setUp(self):
        tmp = tempfile.TemporaryDirectory()
        self.addCleanup(tmp.cleanup)
        self.root = Path(tmp.name)

    def test_relative_file_include(self):
        write(self.root, "extra.Brewfile", 'brew "jq"\n')
        write(self.root, "Brewfile", 'brew "git"\nfile "extra.Brewfile"\n')
        self.assertEqual(compile_lines(self.root), ['brew "git"', 'brew "jq"'])

    def test_hostname_substitution(self):
        write(self.root, f"{brewfile.hostname}.Brewfile", 'brew "jq"\n')
        write(self.root, "Brewfile", 'file "$HOSTNAME.Brewfile"\n')
        self.assertEqual(compile_lines(self.root), ['brew "jq"'])

    def test_tap_section_prefixes_until_blank_line(self):
        write(
            self.root,
            "Brewfile",
            'tap "a/b"\nbrew "one"\ncask "two"\n\nbrew "three"\n',
        )
        self.assertEqual(
            compile_lines(self.root),
            ['tap "a/b"', 'brew "a/b/one"', 'cask "a/b/two"', 'brew "three"'],
        )

    def test_exclude_ignores_tap_prefix(self):
        write(self.root, "Brewfile", 'tap "a/b"\nbrew "dyff"\n\nexclude brew "dyff"\n')
        self.assertEqual(compile_lines(self.root), ['tap "a/b"'])

    def test_exclude_applies_across_files(self):
        write(self.root, "host.Brewfile", 'exclude cask "maccy"\n')
        write(self.root, "Brewfile", 'cask "maccy"\nfile "host.Brewfile"\n')
        self.assertEqual(compile_lines(self.root), [])

    def test_excluding_tap_drops_its_entries(self):
        write(
            self.root,
            "Brewfile",
            'tap "a/b"\nbrew "one"\n\nbrew "keep"\nexclude tap "a/b"\n',
        )
        self.assertEqual(compile_lines(self.root), ['brew "keep"'])

    def test_missing_include_warns_and_skips(self):
        write(self.root, "Brewfile", 'file "nope"\nbrew "git"\n')
        with self.assertLogs("pkgs.brewfile", level="WARNING"):
            self.assertEqual(compile_lines(self.root), ['brew "git"'])


if __name__ == "__main__":
    unittest.main()
