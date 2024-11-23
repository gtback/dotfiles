#!/bin/bash

# SPDX-FileCopyrightText: 2021-2024 Greg Back <git@gregback.net>
# SPDX-License-Identifier: MIT

# Load Backblaze Master Application Key from a password stored in 1Password.

# Usage:
#   eval $(load-b2-token.sh)

set -euo pipefail

SECRET_NAME="Backblaze (OTS)"

cat <<EOF
export B2_APPLICATION_KEY=$(op item get "${SECRET_NAME}" --reveal --fields applicationKey)
export B2_KEY_ID=$(op item get "${SECRET_NAME}" --reveal --fields keyID)
EOF
echo >&2 "Loading Backblaze Master Application Key from '${SECRET_NAME}'"
