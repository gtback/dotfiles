#!/bin/bash

function op.signin() {
    eval "$(op signin "${OP_ACCOUNT}")"
}
