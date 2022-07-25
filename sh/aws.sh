#!/bin/bash

function aws.clear() {
    for e in $(env | grep -i ^AWS_ | awk -F'=' '{ print $1; }'); do
        echo "Unsetting $e"
        unset "$e"
    done
}

function aws.whoami() {
    aws sts get-caller-identity
}
