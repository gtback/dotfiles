#!/bin/bash

# Install most recent patch version of all active Python releases, including
# Python 2.7 (https://www.python.org/downloads). Update the asdf global versions
# file with the new versions.

set -euo pipefail

PY27=$(asdf latest python 2.7)
PY36=$(asdf latest python 3.6)
PY37=$(asdf latest python 3.7)
PY38=$(asdf latest python 3.8)
PY39=$(asdf latest python 3.9)

set -x
asdf install python "${PY27}"
ASDF_PYTHON_PATCH_URL="https://github.com/python/cpython/commit/8ea6353.patch" \
    asdf install python "${PY36}"
asdf install python "${PY37}"
asdf install python "${PY38}"
asdf install python "${PY39}"
asdf global python "$PY39" "$PY38" "$PY37" "$PY36" "system" "$PY27"
asdf reshim python
set +x
