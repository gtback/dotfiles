#!/bin/bash

# SPDX-FileCopyrightText: 2021 Greg Back <git@gregback.net>
# SPDX-License-Identifier: MIT

# Save requirements of all virtualenvs into temporary files

# Usage:
#   allvirtualenv freeze.sh

set -euo pipefail
FILE="${HOME}/tmp/$(basename "${VIRTUAL_ENV}")-requirements.txt"
pip freeze >"${FILE}"
