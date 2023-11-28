#!/bin/bash

# https://www.gnupg.org/documentation/manuals/gnupg/Common-Problems.html
# https://stackoverflow.com/a/57579018
GPG_TTY=$(tty)
GPG_AGENT_INFO=$(gpgconf --list-dirs agent-socket | tr -d '\n' && echo -n ::)
export GPG_TTY GPG_AGENT_INFO
