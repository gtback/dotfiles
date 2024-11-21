#!/bin/bash

function kb.get-github-username() {
    keybase id --json -s "$1" 2>&1 | jq -r '.proofs[].proof | select(.key == "github") | .value'
}
