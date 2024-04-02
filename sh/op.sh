#!/bin/bash

# Allow user to select from a list of items stored in 1Password, then copy that
# item's password to the clipboard.
function op.copy-password() {
    data=$(op item list \
        | jq -r '.[].overview.title' \
        | fzf -1 -q "$1" \
        | xargs -I {} op get item "{}")

    username=$(echo "$data" | jq -r '.details.fields[] | select(.designation == "username").value')

    echo "$data" | jq -r '.details.fields[] | select(.designation == "password").value' | pbcopy

    echo >&2 "Password for '$username' copied to clipboard"
}

function op.get-password() {
    op item get "${1}" --fields password
}
