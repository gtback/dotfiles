#!/usr/bin/env python

# Basic Imports
import os
import sys

# Global - add files you want to ignore in the current directory
IGNORED_FILES = ["README.md", "_bashrc"]

if __name__ == "__main__":
    """
    Run this out of the .dotfiles directory to symlink the appropriate
    files into your home directory
    """

    cwd = os.getcwd()
    home = os.getenv("HOME")

    if not cwd.endswith("dotfiles"):
        print "Are you running this outside of the dotfiles directory?"
        sys.exit(1)

    files = os.listdir(cwd)
    files.sort()

    maxlen = max([len(s) for s in files])
    formatstr = "%%%ds - " % (maxlen + 2)

    for f in files:
        print formatstr % f,
        if f.startswith("setup_"):
            print "Ignoring (setup script)"
            continue

        if f.endswith("~"):
            print "Ignoring (temp file)"
            continue

        if os.path.isdir(f):
            print "Ignoring (directory)"
            continue

        if f in IGNORED_FILES:
            print "Ignoring (explict)"
            continue

        if f.startswith(".") or f.startswith("_"):
            source = os.path.join(cwd, f)
            dest = os.path.join(home, f).replace("_", ".")
            if os.path.exists(dest):
                print "Ignoring (already exists)"
                continue

            try:
                os.symlink(source, dest)
                print "Linked to %s" % dest
            except OSError:
                print "Failed (OSError)"
                raise

        else:
            print "Ignoring (unexpected name)"

    print "\nAdding dotfiles/.bashrc to the end of the ~/.bashrc"
    os.system('echo "source ~/dotfiles/.bashrc" >> $HOME/.bashrc')
