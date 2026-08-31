# Contributing

This is a personal dotfiles repo. This file documents conventions for commit
style, repo structure, and shell code — for both humans and agents making
changes.

## Commit messages

`scope: Imperative description` — colon delimiter, per
<https://scopedcommits.com/>.

Commits before 2026-08 use `[scope] Description`. That bracket form is **not**
the convention going forward; ignore it when inferring style from `git log`.

Scope is usually the top-level directory touched (`vscode`, `git`, `brew`,
`sh`, `mise`). For changes spanning several, use a broader scope or list them
comma-separated; use `global` or `all` only for genuinely tree-wide changes.

## Pre-commit hooks

These run automatically on every commit — write code that passes them:

- `shellcheck` — all shell scripts
- `shfmt -i 4 -bn` — 4-space indent; binary operators (`|`, `&&`, `||`) begin
  continuation lines
- `black` — Python files
- `end-of-file-fixer`, `trailing-whitespace`

## Shell code

### Library vs. script vs. alias

**Aliases** (`sh/aliases`) — pure string substitution, no arguments or logic.

**Functions in `sh/*.sh`** — two cases only:

1. Must run in the current shell (e.g. `kn()` changes kubectl context,
   `cd`-based helpers)
2. Composable library primitives sourced and called by `bin/` scripts

**Scripts in `bin/`** — everything else: self-contained operations that don't
modify shell state, always get `set -euo pipefail`, and benefit from being
runnable standalone.

### `sh/` loading

All `sh/*.sh` files are auto-sourced by `.zshrc` (plus `sh/<os>/*.sh` and
`sh/local/*.sh`). Only `sh/aliases` and `sh/exports` get the `.<os>` /
`.<hostname>` / `.local` cascade. Name files after a topic: `code.sh`,
`brew.sh`, `git.sh`. Functions follow dot-namespacing: `topic.verb` or
`topic.verb-noun`. No `case`-based subcommand dispatch — separate functions per
verb.

### `bin/` script template

```bash
#!/bin/bash

# SPDX-FileCopyrightText: <year> Greg Back <git@gregback.net>
# SPDX-License-Identifier: MIT

# One-line description of what the script does.
# Additional context if needed.
#
# Usage: script-name [args]
# Example: script-name foo

set -euo pipefail

# shellcheck source=../sh/topic.sh
source "${XDG_CONFIG_HOME}/sh/topic.sh"
```

Scripts that use top-level variables from a sourced file need
`# shellcheck disable=SC2154` (shellcheck resolves functions from sourced files
but not always top-level variable assignments).

### Idioms

```bash
# Positional arg with default
arg=${1:-default}

# Arg or interactive fzf picker
NAMESPACE=${1:-$(kubectl get namespaces | fzf | awk '{print $1}')}

# Safe empty-array expansion (works in bash 3.2 + zsh)
for item in ${arr[@]+"${arr[@]}"}; do ...

# Splitting a string into array (works in both bash and zsh)
# shellcheck disable=SC2207
arr=($(printf '%s\n' "$VAR" | tr ', ' '\n' | grep -v '^$'))

# BSD grep workaround: macOS grep mishandles ^$ inside alternation with -E
grep -Ev '^#' "$f" | grep -Ev '^$'   # not: grep -Ev '(^#|^$)'
```

## Repo structure

### Gitignore layers

- `*.local` — any local override (e.g. `sh/exports.local`, `git/config.local`)
- `**/local/**` — private per-machine scripts (e.g. `sh/local/private.sh`)
- `.vscode/*` with explicit allowlist — VS Code workspace files are globally
  gitignored (in `~/.config/git/ignore`); only `settings.json`, `tasks.json`,
  `launch.json`, `extensions.json` are excepted

### Directory naming

Directories that symlink into XDG (`~/.config/`) are lowercase to match the
convention of programs that read them. Directories with custom per-file
symlinking (like `VSCode/`) can be capitalized for visual distinction. Avoid
near-duplicate names that differ only in case — macOS uses a case-insensitive
filesystem by default.

`VSCode/` and `.vscode/` serve different purposes: `.vscode/` is repo workspace
config (read by VS Code when opening this repo), `VSCode/` is user-profile
config (specific files symlinked by `install.sh` into `~/Library/Application
Support/Code/User/`).

### `install.sh` symlink patterns

Two modes:

- **Whole directory:** `symlink sh` → `~/.config/sh` — all files inherit the
  path
- **Per-file:** `symlink VSCode/settings.json
  "$vscode_settings_dir/settings.json"` — when only specific files belong in the
  target

### Named set / profile pattern

Some tools support multiple named configurations tracked in the same directory.
`brewfile/` and `VSCode/extensions` both use this pattern:

| File                       | Purpose                                           |
|----------------------------|---------------------------------------------------|
| `VSCode/extensions`        | Universal base set                                |
| `VSCode/extensions.<name>` | Named add-on (tracked, public IDs)                |
| `VSCode/extensions.local`  | Machine-local overrides (gitignored by `*.local`) |

Machine identity lives in the untracked layer (`sh/local/*.sh`, gitignored by
`**/local/**`). That file exports e.g. `CODE_EXTENSION_PROFILES=private` to opt
the machine in. Named sets are tracked because the IDs are public; secrets and
internal paths are not.

### Dependency declaration

| Tool                    | Where declared                              |
|-------------------------|---------------------------------------------|
| Homebrew formulae/casks | `brewfile/Brewfile` (+ host-specific files) |
| pipx packages           | `pipx/pipx.lock`                            |
| mise-managed runtimes   | `mise/config.toml`                          |
| `npx`-invoked packages  | not declared — worth fixing                 |
