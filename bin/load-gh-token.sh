#!/bin/bash

# Load GitHub API Token from a password stored in 1Password.

# Usage:
#   eval $(load-gh-token.sh)

set -euo pipefail

SECRET_NAME="GitHub API Token - $(hostname -s)"

cat <<EOF
export GITHUB_TOKEN=$(op get item "${SECRET_NAME}" --fields password)
EOF
echo >&2 "Loading GitHub token '${SECRET_NAME}'"
