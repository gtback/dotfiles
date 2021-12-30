#!/bin/bash

# Load Backblaze Master Application Key from a password stored in 1Password.

# Usage:
#   eval $(load-b2-token.sh)

set -euo pipefail

SECRET_NAME="Backblaze (OTS)"

cat <<EOF
export B2_APPLICATION_KEY=$(op get item "${SECRET_NAME}" --fields applicationKey)
export B2_KEY_ID=$(op get item "${SECRET_NAME}" --fields keyID)
EOF
echo >&2 "Loading Backblaze Master Application Key from '${SECRET_NAME}'"
