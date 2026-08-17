#!/bin/bash

vscode_dir="${HOME}/dotfiles/VSCode"
extensions_file="${vscode_dir}/extensions"

# Read one or more extension files, stripping comments and blank lines.
# Safe for glob expansion — silently skips paths that don't exist.
# Two separate greps: BSD grep (macOS) mishandles ^$ inside alternation groups.
code.read-extension-files() {
    for f in "$@"; do
        [[ -f "$f" ]] && grep -Ev '^#' "$f" | grep -Ev '^$'
    done
}

# Emit the sorted union of the base extension list and any requested profile(s).
# Usage: code.configured-extensions [profile ...]
# With no arguments, defaults to $CODE_EXTENSION_PROFILES (space- or comma-separated).
# Example: code.configured-extensions elastic
code.configured-extensions() {
    local profiles=()
    if [[ $# -gt 0 ]]; then
        profiles=("$@")
    elif [[ -n "${CODE_EXTENSION_PROFILES:-}" ]]; then
        # Split CODE_EXTENSION_PROFILES on spaces and commas, drop empty tokens.
        # Using command substitution so word-splitting works in both bash and zsh.
        # shellcheck disable=SC2207
        profiles=($(printf '%s\n' "${CODE_EXTENSION_PROFILES}" \
            | tr ', ' '\n' \
            | grep -v '^$'))
    fi

    {
        code.read-extension-files "$extensions_file"
        for profile in ${profiles[@]+"${profiles[@]}"}; do
            local profile_file="${vscode_dir}/extensions.${profile}"
            if [[ -f "$profile_file" ]]; then
                code.read-extension-files "$profile_file"
            else
                echo "code.configured-extensions: no profile file for '${profile}' (expected ${profile_file})" >&2
            fi
        done
    } | sort -u
}

# Open the git repository of the current directory in VS Code
alias coder="code \$(git rev-parse --show-toplevel)"
