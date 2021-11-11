#!/bin/bash

# Update macOS command line tools
# https://apple.stackexchange.com/a/375535
function xcode.update() {
    sudo rm -rf "$(xcode-select --print-path)"
    sudo xcode-select --install
    sudo xcode-select --reset
}
