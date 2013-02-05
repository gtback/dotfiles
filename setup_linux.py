#!/usr/bin/env python

# Basic Imports
import os
import sys

# Global - add files you want to ignore in the current directory
IGNORED_FILES = [".gitignore", "setup_linux.py", "README.md", ".bashrc"]

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

    os.system('echo "source ~/dotfiles/.bashrc" >> $HOME/.bashrc')

    for f in os.listdir(cwd):
        if f.endswith("~") or os.path.isdir(f) or (f in IGNORED_FILES):
            print "Ignoring temp file or directory: %s" % f
            continue

        elif f.startswith(".") or f.startswith("_"):
            original = os.path.join(cwd, f)
            homeFile = os.path.join(home, f)
            print "Linking: %s --> %s" % (original, homeFile)
            os.symlink(original, homeFile)

        else:
            print "Ignoring unexpected file: %s" % f

    print "Done linking..."
