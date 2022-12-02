#!/bin/bash

# Shell functions for the GitHub CLI (`gh`): https://cli.github.com/

# List all members of a GitHub team:
# Args:
# - team_name
# - org_name (defaults to $GITHUB_ORG if not provided)
function gh.members() {
    # TODO: allow passing `org/team` as a single argument
    team=$1
    org=${2:-$GITHUB_ORG}
    gh api -XGET "orgs/${org}/teams/${team}/members" \
        -Fper-page=100 --paginate --cache 1h \
        | jq -r '.[].login' | sort
}

# Use fzf to select one or more members of a GitHub team and join them with commas
function gh.select-members() {
    gh.members "$@" \
        | fzf --multi \
        | awk 'ORS=","' \
        | sed 's/,$//'
}

function gh.is-org-member() {
    org=$1
    login=$2
    # python ghapi is-member $ORG $USERNAME
    [ "$(gh api -i orgs/"$org"/members/"$login" | head -n 1)" == "HTTP/2.0 204 No Content" ] && echo "Yes" || echo "No"
}

function gh.check-token() {
    token=${1:-$GITHUB_TOKEN}
    http https://api.github.com/user Authorization:"token ${token}"
}

function gh.copy-token() {
    echo "$GITHUB_TOKEN" | pbcopy
}

function gh.rate-limit() {
    token=${1:-$GITHUB_TOKEN}
    http https://api.github.com/rate_limit Authorization:"token ${token}" | jq ".rate | {limit, used, remaining, reset: (.reset | todate) }"
}

function gh.get-repo-id() {
    # TODO: allow passing the repo with or without the owner (user/org) prefix and determine it from $GITHUB_ORG or $GITHUB_USER
    gh api "/repos/$1" | jq -r '.id'
}

function gh.load-token() {
    # TODO: don't reload if $GITHUB_TOKEN already set
    op.signin
    eval "$(load-gh-token.sh)"
}

# Check if GitHub is down
function gh.down() {
    npx -y is-github-down
}
