#!/bin/bash

function pd.load-token {
    op.signin
    eval "$(load-pd-token.sh)"
}
