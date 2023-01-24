#!/bin/bash

function okta.load-token {
    op.signin
    eval "$(load-okta-token.sh)"
}
