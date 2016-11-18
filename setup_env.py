#!/usr/bin/env python
"""Symlink appropriate files into your home directory."""

import os

# Global - add files you want to ignore in the current directory
IGNORED = ["README.md", "_bashrc", ".git", "windows", "bundles.vim"]

def main():
    dotfiles_dir = os.path.dirname(os.path.realpath(__file__))
    home = os.getenv("HOME")

    dotfiles = os.listdir(dotfiles_dir)
    dotfiles.sort()

    maxlen = max([len(s) for s in dotfiles])
    formatstr = "%%%ds -" % (maxlen + 2)

    for f in dotfiles:
        print formatstr % f,
        if f.startswith("setup_"):
            print "Ignoring (setup script)"
            continue

        if f.endswith("~"):
            print "Ignoring (temp file)"
            continue

        if f in IGNORED:
            print "Ignoring (explict)"
            continue

        if f.startswith("_"):
            source = os.path.join(dotfiles_dir, f)
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

    bashrc = os.path.join(home, ".bashrc")

    bashrc_line = "source ~/dotfiles/_bashrc"

    found = False
    if os.path.exists(bashrc):
        with open(bashrc) as f:
            for line in f:
                if line.strip() == bashrc_line:
                    print "\n.bashrc has already been modified."
                    found = True
                    break

    if not found:
        print "\nAdding dotfiles/.bashrc to the end of the ~/.bashrc"
        os.system('echo "%s" >> $HOME/.bashrc' % bashrc_line)

if __name__ == "__main__":
    main()
