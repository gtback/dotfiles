#!/bin/bash

DIRENV_DATA=${XDG_DATA_HOME}/direnv

function direnv.clean() {
    rm "${DIRENV_DATA}/allow/"*
}
