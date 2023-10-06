#!/bin/bash

export HOMEBREW_BUNDLE_NO_LOCK=1
export HOMEBREW_CLEANUP_MAX_AGE_DAYS=14
export HOMEBREW_NO_ENV_HINTS=1

# https://docs.brew.sh/Analytics#opting-out
export HOMEBREW_NO_ANALYTICS=1

export HOMEBREW_BAT=1
export HOMEBREW_INSTALL_BADGE="✅"

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

# # Don't use `brew-wrap` (yet!)
# # https://homebrew-file.readthedocs.io/en/latest/installation.html
# if [ -f "$(brew --prefix)/etc/brew-wrap" ];then
#   source "$(brew --prefix)/etc/brew-wrap"
# fi
