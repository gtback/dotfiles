#!/bin/sh

set -euo pipefail

fd Brewfile ${HOME} -x cat | egrep -v "(^#|^$)" | sort -u > /tmp/Brewfile.combined
brew bundle dump --no-restart --file=- | sort -u > /tmp/Brewfile.installed

diff /tmp/Brewfile.{installed,combined}
