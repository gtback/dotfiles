#!/bin/bash

# Allow user to select from a list of items stored in 1Password, then copy that
# item's password to the clipboard.
function op.copy-password() {
    data=$(op item list --format json \
        | jq -r '.[] | [.id, .title,  "(" + .additional_information + ")"] | @tsv' \
        | sort \
        | fzf -1 -q "$1" --with-nth 2,3 --bind 'enter:become(echo {1})' \
        | xargs -I {} op item get "{}" --format json)

    username=$(echo "$data" | jq -r '.fields[] | select(.purpose == "USERNAME").value')

    echo "$data" | jq -r '.fields[] | select(.purpose == "PASSWORD").value' | pbcopy

    echo >&2 "Password for '$username' copied to clipboard"
}

function op.get-password() {
    op item get "${1}" --reveal --fields password
}
