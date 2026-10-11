# frozen_string_literal: true

brew "ffmpeg"
brew "rtl_433"

cask "adobe-digital-editions"
cask "anki"
cask "backblaze"
cask "balenaetcher"
cask "bitwarden"
cask "docker-desktop"
cask "drawio"
cask "dropbox"
cask "firefox"
cask "jellyfin"
cask "libreoffice-still"
cask "netnewswire"
cask "quicken"
cask "thunderbird"
cask "ungoogled-chromium"
cask "xmind"

mas "Apple Configurator", id: 1037126344
mas "Brother iPrint&Scan", id: 1193539993
mas "Cardhop", id: 1290358394
mas "Okta Verify", id: 490179405
mas "WireGuard", id: 1451685025

# Moved to mise (see mise/config.plato.toml) to get prebuilt binaries instead
# of from-source builds now that Homebrew has dropped Intel-macOS bottles
# past Sonoma.
exclude brew "direnv"
exclude brew "dust"
exclude brew "fd"
exclude brew "fzf"
exclude brew "gh"
exclude brew "pipx"
exclude brew "shfmt"
exclude brew "tmux"

# broot's mise backend (github:canop/broot) only bundles an aarch64-apple-darwin
# binary in its release zip despite shipping a separate x86_64-apple-darwin
# tarball upstream, so it doesn't work via mise on this Intel host. Not
# important enough to keep on Homebrew just for this.
exclude brew "broot"

# Not needed on plato, and impractical to install here: none has an Intel
# bottle. blueutil needs a full Xcode.app to build, pandoc builds with
# ghc/cabal, and yq needs go plus pandoc.
exclude brew "blueutil"
exclude brew "pandoc"
exclude brew "yq"
