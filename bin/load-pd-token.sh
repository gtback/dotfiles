#!/bin/bash

# Load PagerDuty API Token from a password stored in 1Password.

# Usage:
#   eval $(load-pd-token.sh)

set -euo pipefail

SECRET_NAME="PagerDuty API Token"

cat <<EOF
export PAGERDUTY_API_TOKEN=$(op item get "${SECRET_NAME}" --reveal --fields password)
EOF
echo >&2 "Loading '${SECRET_NAME}'"
