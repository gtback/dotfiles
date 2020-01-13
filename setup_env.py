#!/usr/bin/env python3
"""Symlink appropriate files into your home directory."""

import os

DOTFILES_DIR = os.path.dirname(os.path.realpath(__file__))
HOME = os.getenv("HOME")

# Global - add files you want to ignore in the current directory
IGNORED = ["README.md", "_bashrc", ".git", "windows", "bundles.vim"]

DIRS = {
    'VSCode': os.path.join(HOME, 'Library', 'Application Support', 'Code', 'User'),
}

def link(filename, dest_dir=HOME, src_dir=None):
    if src_dir:
        source = os.path.join(DOTFILES_DIR, src_dir, filename)
    else:
        source = os.path.join(DOTFILES_DIR, filename)
    dest = os.path.join(dest_dir, filename).replace("_", ".", 1)

    if os.path.exists(dest):
        print("Ignoring (already exists)")
        return
    try:
        os.symlink(source, dest)
        print("Linked to %s" % dest)
    except OSError:
        print("Failed (OSError)")
        raise


def main():
    dotfiles = os.listdir(DOTFILES_DIR)
    dotfiles.sort()

    maxlen = max([len(s) for s in dotfiles])
    formatstr = "%%%ds -" % (maxlen + 2)

    for f in dotfiles:
        print(formatstr % f, end=" ")
        if f.startswith("setup_"):
            print("Ignoring (setup script)")
        elif f in DIRS:
            subdir = os.path.join(DOTFILES_DIR, f)
            target_dir = DIRS[f]
            for nested in os.listdir(subdir):
                link(nested, target_dir, subdir)
        elif f.endswith("~"):
            print("Ignoring (temp file)")
        elif f in IGNORED:
            print("Ignoring (explict)")
        elif f.startswith("_"):
            link(f)
        else:
            print("Ignoring (unexpected name)")

    bashrc = os.path.join(HOME, ".bashrc")

    bashrc_line = "source ~/dotfiles/_bashrc"

    found = False
    if os.path.exists(bashrc):
        with open(bashrc) as f:
            for line in f:
                if line.strip() == bashrc_line:
                    print("\n.bashrc has already been modified.")
                    found = True
                    break

    if not found:
        print("\nAdding dotfiles/.bashrc to the end of the ~/.bashrc")
        os.system('echo "%s" >> $HOME/.bashrc' % bashrc_line)


if __name__ == "__main__":
    main()
