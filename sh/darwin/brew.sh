#!/bin/bash

OS_ARCH=$(uname -m)

# This is the output of `brew shellenv`, but doesn't assume that `brew` is
# currently available on `$PATH`.
if [ "$OS_ARCH" == "arm64" ]; then
    export HOMEBREW_PREFIX="/opt/homebrew";
    export HOMEBREW_CELLAR="/opt/homebrew/Cellar";
    export HOMEBREW_REPOSITORY="/opt/homebrew";
    export PATH="/opt/homebrew/bin:/opt/homebrew/sbin${PATH+:$PATH}";
    export MANPATH="/opt/homebrew/share/man${MANPATH+:$MANPATH}:";
    export INFOPATH="/opt/homebrew/share/info:${INFOPATH:-}";
fi

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
    fd -I Brewfile "${HOME}/code" "${HOME}/dotfiles"
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
