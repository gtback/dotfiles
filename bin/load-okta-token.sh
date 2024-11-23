#!/bin/bash

# SPDX-FileCopyrightText: 2023-2024 Greg Back <git@gregback.net>
# SPDX-License-Identifier: MIT

# Load Okta API Token from a password stored in 1Password.

# Usage:
#   eval $(load-okta-token.sh)

set -euo pipefail

SECRET_NAME=${1:-"Okta API Token"}

cat <<EOF
export OKTA_API_TOKEN=$(op item get "${SECRET_NAME}" --reveal --fields password)
EOF
echo >&2 "Loading '${SECRET_NAME}'"
