#!/bin/bash

# Load Okta API Token from a password stored in 1Password.

# Usage:
#   eval $(load-okta-token.sh)

set -euo pipefail

SECRET_NAME="Okta API Token"

cat <<EOF
export OKTA_API_TOKEN=$(op get item "${SECRET_NAME}" --fields password)
EOF
echo >&2 "Loading '${SECRET_NAME}'"