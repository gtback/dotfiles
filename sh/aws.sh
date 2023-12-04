#!/bin/bash

function aws.clear() {
    for e in $(env | grep -i "^AWS_" | awk -F'=' '{ print $1; }'); do
        echo "Unsetting $e"
        unset "$e"
    done
}

function aws.whoami() {
    aws sts get-caller-identity
}

function aws.decode() {
    aws sts decode-authorization-message --encoded-message "$1" --output text | jq .
}
