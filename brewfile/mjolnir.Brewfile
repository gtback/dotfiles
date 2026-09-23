# frozen_string_literal: true

# Excluded from the shared Brewfile: not wanted or not usable on this host
# (still wanted on plato/seneca, so don't comment these out of the base file).

# We don't need `dyff` on this machine
exclude tap "homeport/tap"

# I haven't bothered to set up LanguageTool on mjolnir
exclude brew "languagetool"
exclude cask "languagetool-desktop"

# These require compiling on this machine, and aren't often used
exclude brew "neovim"

# I don't use these on mjolnir (to keep it leaner)
exclude cask "grandperspective"
exclude cask "logitech-options"
exclude cask "yubico-authenticator"

# Maccy requires Sonoma or newer, so use Clipy instead
exclude cask "maccy"
cask "clipy"

# On mjolnir, we use Sublime Text instead of VS Code
exclude cask "visual-studio-code"
cask "sublime-text"

# `mas` needs to be compiled on machines this old, and none of these are cricital
exclude brew "mas"
exclude mas "Amphetamine"
exclude mas "Fantastical"
exclude mas "Speedtest"
exclude mas "Todoist"
exclude mas "Velja"

# Other Homebrew packages
brew "bitwarden-cli"

# Other Cask applications
cask "claude-code"
cask "dropbox"
cask "netnewswire"
