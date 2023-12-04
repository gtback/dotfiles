#!/bin/bash

function tf.apply-workspace() {
    pushd "$1" || return
    make init
    make apply
    popd || return
}
