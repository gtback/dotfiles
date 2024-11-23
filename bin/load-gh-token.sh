#!/bin/bash

# SPDX-FileCopyrightText: 2021-2023 Greg Back <git@gregback.net>
# SPDX-License-Identifier: MIT

# Load GitHub API Token from a password stored in 1Password.

# Usage:
#   eval $(load-gh-token.sh)

set -euo pipefail

# shellcheck source=../sh/op.sh
source "${XDG_CONFIG_HOME}/sh/op.sh"

SECRET_NAME=${SECRET_NAME:-"GitHub API Token - $(hostname -s)"}

cat <<EOF
export GITHUB_TOKEN=$(op.get-password "${SECRET_NAME}")
EOF
echo >&2 "Loading GitHub token '${SECRET_NAME}'"
