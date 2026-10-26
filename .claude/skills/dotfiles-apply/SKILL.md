---
name: dotfiles-apply
description: Check which recent dotfiles changes still need to be applied on this machine. Use for requests like "check what recent dotfiles changes need applied", "sync dotfiles on this host", or "what do I need to run after pulling dotfiles".
---

# dotfiles-apply

`bin/dotfiles.applied` records the last dotfiles commit applied on this
machine (`$XDG_STATE_HOME/dotfiles/applied`). This skill turns the commits
since then into a checklist.

## Steps

1. **Check the checkout.** `git -C ~/dotfiles status -sb`. If it is behind
   `origin`, tell the user to pull; don't pull for them.
2. **Find the marker.** Run `dotfiles.applied`.
   - **Nothing recorded:** treat this as a new machine. Walk through
     README.md "Set up macOS" as a numbered checklist, skipping steps the user
     says are done. Then go to step 5.
   - **Not an ancestor of HEAD** (`git merge-base --is-ancestor <sha> HEAD`
     fails, e.g. after a rebase): ask the user which commit to start from.
3. **List the changes.**
   `git -C ~/dotfiles log --reverse --name-status <marker>..HEAD`. If empty,
   say the machine is up to date and stop. Read commit bodies, not just paths:
   they often say what to do by hand.
4. **Build the checklist.** One line per action, with the commits that need
   it, in this order:

   | Changed path | Action |
   | --- | --- |
   | `install.sh` | `./install.sh` |
   | `brewfile/**` | `brew.up` |
   | `pipx/**` | `pipx.up` |
   | `mise/**` | `mise install` |
   | `claude/settings.json`, `claude/settings.json.local`, `sh/claude.sh` | `claude.render` |
   | `claude/mcp/**` | `claude.mcp-sync` |
   | `pi/**` | `pi.mcp-render` |
   | `VSCode/**` | `code.install-extensions` if extensions changed |
   | `vim/**`, `setup_vim.sh` | `./setup_vim.sh` |
   | new symlink to a `*.local` file | create the untracked local file by hand |
   | `zsh/**`, `sh/**`, `env/**` | restart the shell |
   | README "Set up macOS" | read the diff for new one-time steps |

   Everything else (`bin/`, `agents/`, `claude/CLAUDE.md`, docs) is live
   through symlinks or `PATH`: no action.
5. **Apply.** Run each step only after the user confirms it. Give the user
   commands that use 1Password, Vault, SSH or AWS to run themselves
   (`pi.mcp-render` uses 1Password).
6. **Record it.** When every step is done or skipped, offer
   `dotfiles.applied --set`.

## Conventions

- Never commit or pull.
- Never write `*.local` files; describe what they need. They may hold
  credentials.
