#!/bin/bash

brew.find-all-brewfiles() {
    # - Find all Brewfiles in code/ and dotfiles/
    # - Find any Brewfiles in the home directory (if any exist)
    fd Brewfile "${HOME}/code" "${HOME}/dotfiles"
    fd --max-depth 1 Brewfile "${HOME}"
}

brew.find-brewfiles() {
    # - Remove all files listed in the BREWFILE_IGNORE variable (typically used for
    #   files for other hostnames)
    brew.find-all-brewfiles \
        | grep -E -v "${BREWFILE_IGNORE:-xxxxxx}"
}
