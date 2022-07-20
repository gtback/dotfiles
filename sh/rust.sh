#!/bin/bash

# Inspired by:
#   https://stevedonovan.github.io/rust-gentle-intro/readme.html
#
# Renamed "rrun" -> "ox" to avoid conflicting with "ruby run" from Oh-My-Zsh:
# https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/ruby
#
# "ox" is short for "oxidize" ;-)
function ox() {
    rustc "$1.rs" && "./$1"
}
