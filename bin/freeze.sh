#!/bin/bash

# Save requirements of all virtualenvs into temporary files

# Usage:
#   allvirtualenv freeze.sh

set -euo pipefail
FILE="${HOME}/tmp/$(basename "${VIRTUAL_ENV}")-requirements.txt"
pip freeze >"${FILE}"
