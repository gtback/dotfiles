---
name: brew-audit
description: Audit the Brewfiles for formulae, casks and Mac App Store apps that are no longer used, and decide where each removal belongs. Use for requests like "audit Brewfiles", "what brew stuff don't I use", or "prune formulae".
---

# brew-audit

`bin/brew.usage` supplies the facts; this skill supplies the judgement. The
script scores each Brewfile entry from shell history (mcfly, with aliases
credited to their targets) and Spotlight's last-used date for apps.

## Steps

1. **Run the report.** Run `brew.usage` on this host (`--days N` changes the
   window; the default is 365). Ask the user to run it on the other hosts and
   paste the output.
2. **Triage stale rows.** Many are false positives:
   - shell integrations (starship, mcfly, direnv, fzf, zoxide, antidote)
   - dependencies of other tools (pinentry-mac, docker plugins,
     lima-additional-guestagents)
   - editor dependencies (ctags, enchant, languagetool)
   - shell-function entry points that alias parsing misses (broot's `br`)
   - menu-bar and background apps, which `mdls` reports as never opened
     (Fantastical, Bartender, Tailscale)
   - fonts, and casks that install only pkgs or drivers (shown with `-`
     in PROVIDES, so they have no signal at all)
   - "nice to have everywhere" tools the user keeps deliberately
3. **Ask before deciding.** Present candidates grouped by confidence and ask
   the user. Don't decide for them.
4. **Choose the placement** for each removal:
   - remove from the base Brewfile
   - move to a host file
   - `exclude` in a host file
   - update or delete now-dead `exclude` lines
5. **Clean up leftovers.**
   - Grep `README.md`, `CONTRIBUTING.md`, `sh/`, and `brewfile/presets/` for
     references to removed tools.
   - If a removed tool has its own config directory in the repo, propose
     deleting it together with its `install.sh` symlink lines.
   - Then give the matching `brew uninstall` (and `--cask`) commands for each
     host. `brew.diff` lists what is installed but no longer in the Brewfile.
6. **Stop at edits.** Never edit without confirmation, and never commit.

## Conventions

- The cutoff is 12 months.
- A tap on its own can be the whole install (`martido/graph`), so don't
  remove a tap just because it has no formulae listed.
