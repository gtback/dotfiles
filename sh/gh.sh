#!/bin/bash

# Shell functions for the GitHub CLI (`gh`): https://cli.github.com/

# Don't use GitHub Token environment variable, even if one is set.
alias gh="GITHUB_TOKEN= gh"

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

function gh.require-org() {
    if [[ -z "${GITHUB_ORG:-}" ]]; then
        echo "gh.require-org: \$GITHUB_ORG is not set" >&2
        return 2
    fi
}

# Check whether a GitHub login is a member of an organization.
# Echoes "Yes" or "No" for interactive use.
# Exit status: 0 = member, 1 = not a member, 2 = could not determine.
function gh.is-org-member() {
    org=$1
    login=$2
    if [[ -z "$org" || -z "$login" ]]; then
        echo "gh.is-org-member: usage: gh.is-org-member <org> <login>" >&2
        return 2
    fi

    local out code
    out=$(gh api -i "orgs/${org}/members/${login}" 2>&1)
    # Parse status code from response header (HTTP/x.x NNN) or gh error message (HTTP NNN)
    code=$(printf '%s\n' "$out" | grep -m1 -oE '^HTTP/[0-9.]+ [0-9]{3}' | awk '{print $2}')
    if [[ -z "$code" ]]; then
        code=$(printf '%s\n' "$out" | grep -oE '\(HTTP [0-9]{3}\)' | head -1 | grep -oE '[0-9]{3}')
    fi

    case "$code" in
    204) echo "Yes" ;;
    404)
        echo "No"
        return 1
        ;;
    302)
        echo "gh.is-org-member: cannot determine membership -- requester is not a member of '${org}'" >&2
        return 2
        ;;
    *)
        echo "gh.is-org-member: unexpected response for '${org}/${login}' (HTTP ${code:-unknown}): ${out}" >&2
        return 2
        ;;
    esac
}

function gh.check-token() {
    token=${1:-$GITHUB_TOKEN}
    http --check-status https://api.github.com/user Authorization:"token ${token}"
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
    eval "$(load-gh-token.sh)"
}

# Check if GitHub is down
function gh.down() {
    npx -y is-github-down
}

# Find the GitHub App Installation ID within a particular organization.
# The argument is a regular expression used to find the app name. It doesn't need to be an exact match as long as it's unique.
# Requires a GitHub personal access token with `admin:org` permissions.
function gh.get-installation-id() {
    app=${1:-renovate}
    gh api "/orgs/${GITHUB_ORG}/installations?per_page=100" | jq -r '.installations[] | [.id, .app_slug] | @tsv' | rg "$app" | head -1 | awk -F '\t' '{print $1}'
}

# Find all the repos that a particular GitHub App is enabled on.
# The argument is a regular expression used to find the app name. It doesn't need to be an exact match as long as it's unique.
# Requires a GitHub personal access token with `admin:org` permissions.
function gh.app-repos() {
    install_id=$(gh.get-installation-id "$1")
    gh api "/user/installations/${install_id}/repositories?per_page=100" | jq -r '.repositories[].name'
}

function gh.open() {
    open "https://github.$(git config remote.origin.url | cut -f2 -d. | tr ':' /)/blob/$(
        git rev-parse --abbrev-ref HEAD
    )/$(git ls-files --full-name "$1")"
}
