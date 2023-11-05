#!/bin/bash

alias pyws="sed -i -e 's/^[ \r\t]*$//'"
alias pip.rm-all="python -m pip freeze | sed 's/^-e.*egg=//' | xargs python -m pip uninstall -y"

export WORKON_HOME="$HOME/.virtualenvs"
export PROJECT_HOME="$HOME/code"
export VIRTUAL_ENV_DISABLE_PROMPT=true

export PYTHONSTARTUP="$HOME/.pythonstartup"

pip.upgrade-all() {
    python -m pip list --outdated --disable-pip-version-check | awk 'NR>2 {print $1 "==" $3}' | xargs python -m pip install
}

# Check if there's an existing alias for pip, and if so, remove it.
alias pip &>/dev/null && unalias pip
function pip() {
    echo >&2 "Use 'python -m pip' instead"
}
