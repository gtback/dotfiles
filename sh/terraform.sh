#!/bin/bash

function tf.apply-workspace() {
    pushd "$1" || return
    make init
    make apply
    popd || return
}

# List all resources defined in a Terraform HCL file, to make it easier to
# create `-target` expressions for use with `terraform plan` and `terraform
# apply`
function tf.list-resources() {
    # Use first filename, otherwise stdin
    input=${1:--}

    # Use `sd` to replace $1 and $2, rather than letting the shell expand them.
    # shellcheck disable=SC2016
    grep ^resource "$input" | sd '.*"(.*)" "(.*)".*' '$1.$2'
}
