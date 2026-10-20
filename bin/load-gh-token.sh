#!/bin/bash

# SPDX-FileCopyrightText: 2021-2023 Greg Back <git@gregback.net>
# SPDX-License-Identifier: MIT

# Load GitHub API Token from a password stored in 1Password.

# Usage:
#   SECRET_NAME="<1Password item name>" eval $(load-gh-token.sh)
#
# SECRET_NAME is required: the name of the 1Password item whose `credential`
# field holds the token. In a shell, `SECRET_NAME=... gh.load-token` does the
# same (see sh/gh.sh).

set -euo pipefail

# shellcheck source=../sh/op.sh
source "${XDG_CONFIG_HOME}/sh/op.sh"

SECRET_NAME=${SECRET_NAME:?set SECRET_NAME to the 1Password item name}

cat <<EOF
export GITHUB_TOKEN=$(op.get-credential "${SECRET_NAME}")
EOF
echo >&2 "Loading GitHub token '${SECRET_NAME}'"
