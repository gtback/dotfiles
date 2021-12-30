#!/bin/bash

# Backblaze API functions

b2.load-master-key() {
    op.signin
    eval "$(load-b2-master-key.sh)"
}

b2.authorize() {
    # https://www.backblaze.com/b2/docs/b2_authorize_account.html
    account_info="$(curl -s https://api.backblazeb2.com/b2api/v2/b2_authorize_account -u "${B2_KEY_ID}:${B2_APPLICATION_KEY}")"
    api_url=$(jq -r ".apiUrl" <(echo "${account_info}"))
    auth_token=$(jq -r ".authorizationToken" <(echo "${account_info}"))

    echo "API URL: $api_url"
    echo "Authorization Token: $auth_token"
}
