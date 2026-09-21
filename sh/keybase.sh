#!/bin/bash

# Shell functions for Keybase CLI: https://keybase.io

command -v keybase &>/dev/null || return

function kb.require-team() {
    if [[ -z "${KEYBASE_TEAM:-}" ]]; then
        echo "kb.require-team: \$KEYBASE_TEAM is not set" >&2
        return 2
    fi
}

function kb.get-github-username() {
    local username=$1
    if [[ -z "$username" ]]; then
        echo "kb.get-github-username: usage: kb.get-github-username <keybase-user>" >&2
        return 2
    fi

    local out rc
    out=$(keybase id --json -s "$username")
    rc=$?
    if [[ $rc -ne 0 ]]; then
        echo "kb.get-github-username: keybase id failed for '${username}'" >&2
        return 1
    fi

    local gh_user
    gh_user=$(printf '%s\n' "$out" \
        | jq -r '.proofs[].proof | select(.key == "github") | .value')
    if [[ -z "$gh_user" ]]; then
        echo "kb.get-github-username: '${username}' has no proven GitHub account" >&2
        return 1
    fi
    printf '%s\n' "$gh_user"
}

function kb.get-requests() {
    kb.require-team || return

    local out rc
    out=$(keybase team list-requests --json "$KEYBASE_TEAM" 2>&1)
    rc=$?
    if [[ $rc -ne 0 ]]; then
        echo "kb.get-requests: keybase team list-requests failed: ${out}" >&2
        return 1
    fi

    local usernames
    if ! usernames=$(printf '%s\n' "$out" | jq -r '.[].username' 2>/dev/null); then
        echo "kb.get-requests: failed to parse response: ${out}" >&2
        return 1
    fi
    printf '%s\n' "$usernames"
}

function kb.add-user() {
    kb.require-team || return
    local kb_username=$1
    if [[ -z "$kb_username" ]]; then
        echo "kb.add-user: usage: kb.add-user <keybase-user> [role]" >&2
        return 2
    fi
    local role=${2:-writer}
    if ! keybase team add-member "$KEYBASE_TEAM" --user "$kb_username" --role "${role}"; then
        echo "kb.add-user: failed to add '${kb_username}' to team '${KEYBASE_TEAM}'" >&2
        return 1
    fi
}

function kb.verify-org-member() {
    gh.require-org || return

    local kb_username=$1
    if [[ -z "$kb_username" ]]; then
        echo "kb.verify-org-member: usage: kb.verify-org-member <keybase-user>" >&2
        return 2
    fi

    echo "Keybase user: $kb_username"
    local gh_username
    gh_username=$(kb.get-github-username "${kb_username}") || return
    echo "GitHub user: $gh_username"

    local rc
    gh.is-org-member "$GITHUB_ORG" "$gh_username" >/dev/null
    rc=$?
    if [[ $rc -eq 0 ]]; then
        echo "'$gh_username' is a member of GitHub organization '$GITHUB_ORG'"
    elif [[ $rc -eq 1 ]]; then
        echo "'$gh_username' is not a member of GitHub organization '$GITHUB_ORG'"
        return 1
    else
        return 2
    fi
}

function kb.check-requests() {
    kb.require-team || return
    gh.require-org || return

    local requests
    requests=$(kb.get-requests) || return

    if [[ -z "$requests" ]]; then
        echo "No pending requests for Keybase team '${KEYBASE_TEAM}'"
        return 0
    fi

    local rc
    while IFS= read -r kb_username; do
        kb.verify-org-member "$kb_username"
        rc=$?
        if [[ $rc -eq 0 ]]; then
            kb.add-user "$kb_username"
            echo "Added '$kb_username' to Keybase team '${KEYBASE_TEAM}'"
        elif [[ $rc -eq 2 ]]; then
            echo "kb.check-requests: skipping '${kb_username}' -- membership could not be determined" >&2
        fi
        # rc=1 means not a member; kb.verify-org-member already said so, skip to next
    done <<<"$requests"
}

function kb.remove-user() {
    kb.require-team || return
    local kb_username=$1
    if [[ -z "$kb_username" ]]; then
        echo "kb.remove-user: usage: kb.remove-user <keybase-user>" >&2
        return 2
    fi
    if ! keybase team remove-member "$KEYBASE_TEAM" --user "$kb_username"; then
        echo "kb.remove-user: failed to remove '${kb_username}' from team '${KEYBASE_TEAM}'" >&2
        return 1
    fi
}
