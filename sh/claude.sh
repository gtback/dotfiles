#!/bin/bash

# SPDX-FileCopyrightText: 2026 Greg Back <git@gregback.net>
# SPDX-License-Identifier: MIT

claude_dir="${HOME}/dotfiles/claude"

# List settings layer file paths in merge order. Outputs one path per line,
# silently skipping files that do not exist. Warns on a named profile with no file.
# Usage: claude.settings-layers [profile ...]
# With no arguments, defaults to $CLAUDE_PROFILES (space- or comma-separated).
claude.settings-layers() {
    local profiles=()
    if [[ $# -gt 0 ]]; then
        profiles=("$@")
    elif [[ -n "${CLAUDE_PROFILES:-}" ]]; then
        # Split CLAUDE_PROFILES on spaces and commas, drop empty tokens.
        # shellcheck disable=SC2207
        profiles=($(printf '%s\n' "${CLAUDE_PROFILES}" \
            | tr ', ' '\n' \
            | grep -v '^$'))
    fi

    local base="${claude_dir}/settings.json"
    [[ -f "$base" ]] && echo "$base"

    for profile in ${profiles[@]+"${profiles[@]}"}; do
        local profile_file="${claude_dir}/settings.json.${profile}"
        if [[ -f "$profile_file" ]]; then
            echo "$profile_file"
        else
            echo "claude.settings-layers: no profile file for '${profile}' (expected ${profile_file})" >&2
        fi
    done

    local local_file="${claude_dir}/settings.json.local"
    [[ -f "$local_file" ]] && echo "$local_file"
}

# List MCP server layer file paths in merge order. Outputs one path per line,
# silently skipping paths that do not exist.
claude.mcp-layers() {
    local base="${claude_dir}/mcp/servers.json"
    [[ -f "$base" ]] && echo "$base"

    # local/ may not exist on a fresh clone; [[ -f ]] handles unmatched globs.
    set +f
    for f in "${claude_dir}/mcp/local/"*.json; do
        [[ -f "$f" ]] && echo "$f"
    done
    set -f
}

# Deep-merge JSON files using jq. Objects merge recursively; arrays concatenate
# and deduplicate. All input files must be valid JSON (no JSONC comments).
# Usage: claude.deepmerge file1.json [file2.json ...]
claude.deepmerge() {
    jq -s '
        # $a/$b are value parameters (eagerly bound), avoiding jq call-by-name pitfalls.
        def deepmerge($a; $b):
            if ($a|type) == "object" and ($b|type) == "object"
            then reduce ($b|keys_unsorted[]) as $k ($a; .[$k] = deepmerge($a[$k]; $b[$k]))
            elif ($a|type) == "array" and ($b|type) == "array"
            then ($a + $b) | unique
            elif $b == null then $a
            else $b end;
        if length == 1 then .[0]
        else reduce .[1:][] as $layer (.[0]; deepmerge(.; $layer)) end
    ' "$@"
}
