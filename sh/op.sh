#!/bin/bash

function op.signin() {
    if op.is-session-active; then
        echo "op: already signed in"
    else
        eval "$(op signin "${OP_ACCOUNT}")"
    fi
}

function op.is-session-active() {
    # Exit code is 0 if active, 1 if inactive
    op get account 2>/dev/null >&2
}
