#!/bin/bash

set -euo pipefail

latest-py() {
    pyenv install --list | xargs -n 1 echo | rg "$1" | tail -1
}

PY27=$(latest-py "^2\.7\.")
PY36=$(latest-py "^3\.6\.")
PY37=$(latest-py "^3\.7\.")
PY38=$(latest-py "^3\.8\.")
PY39=$(latest-py "^3\.9\.")

pyinstall() {
    pyenv install --skip-existing "$@"
}

set -x
pyinstall "$PY27"
# https://github.com/pyenv/pyenv/issues/1643
pyinstall "$PY36" --patch < <(curl -sSL https://github.com/python/cpython/commit/8ea6353.patch)
pyinstall "$PY37"
pyinstall "$PY38"
pyinstall "$PY39"
pyenv global "$PY39" "$PY38" "$PY37" "$PY36" "system" "$PY27"
pyenv rehash
set +x
