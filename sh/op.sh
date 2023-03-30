#!/bin/bash

# Log into the 1Password CLI (op).
#
# Unlike the `op signin` command, this function:
# - checks if you're logged in first; this makes it easier to use in scripts
#   without needing to type your master password multiple times.
# - loops until a correct password is provided (or exited with CTRL-C)
function op.signin() {
    if op.is-session-active; then
        echo >&2 "op: already signed in"
    else
        echo >&2 "op: need to sign in"
        while ! output=$(op signin "${OP_ACCOUNT}"); do
            echo >&2 "incorrect password, try again"
        done
        echo >&2 "Signed in successfully"
        eval "$output"
    fi
}

function op.is-session-active() {
    # Exit code is 0 if active, 1 if inactive
    op get account 2>/dev/null >&2
}

# Allow user to select from a list of items stored in 1Password, then copy that
# item's password to the clipboard.
function op.copy-password() {
    op.signin
    data=$(op list items \
        | jq -r '.[].overview.title' \
        | fzf -1 -q "$1" \
        | xargs -I {} op get item "{}")

    username=$(echo "$data" | jq -r '.details.fields[] | select(.designation == "username").value')

    echo "$data" | jq -r '.details.fields[] | select(.designation == "password").value' | pbcopy

    echo >&2 "Password for '$username' copied to clipboard"
}

function op.get-password() {
    op.signin
    op get item "${1}" --fields password
}
