#!/bin/bash

### Git aliases
alias ga='git add'
alias gb='git branch'
alias gba='git branch --all'
alias gc='git commit'
alias gco='git checkout'
alias gd='git diff'
alias gdca='git diff --cached'
alias gfa='git fetch --all'
alias glg='git lg'
alias gls='git log --stat'
alias gm='git merge'
alias grv='git remote -v'
alias gsd='git stash drop'
alias gsl='git stash list'
alias gst='git status'

# Run a `diff` that doesn't use `delta` as the pager, meaning the output can be
# pasted directly into GitHub, etc.
alias g.diff='git -c core.pager= diff'

# Update the local default branch (main/master) from origin without switching to
# it, so uncommitted work is never touched.
function gum() {
    local head
    head="$(git.remote-head)"
    if [ -z "$head" ]; then
        echo >&2 "Cannot resolve HEAD branch for 'origin'. Run: git remote set-head origin --auto"
        return 1
    fi

    git fetch --prune origin || return 1

    if [ "$(git symbolic-ref --short HEAD 2>/dev/null)" = "$head" ]; then
        git merge --ff-only "origin/$head"
    else
        # Fast-forwards the local branch without checking it out
        git fetch . "origin/$head:$head"
    fi
}

# Park uncommitted work (including untracked files) as a commit on the current
# branch. Use instead of `git stash`: the work stays attached to its branch.
# Undo with `git.unwip`.
function git.wip() {
    local branch
    branch="$(git symbolic-ref --short HEAD)" || return 1
    git add --all \
        && git commit --no-verify --no-gpg-sign -m "WIP on ${branch}: DO NOT PUSH/MERGE"
}

# Undo `git.wip`, leaving the changes uncommitted (new files become untracked).
function git.unwip() {
    local subject
    subject="$(git log -1 --format=%s)"
    case "$subject" in
    "WIP on "*": DO NOT PUSH/MERGE")
        git reset HEAD~1
        ;;
    *)
        echo >&2 "Last commit is not a git.wip commit: $subject"
        return 1
        ;;
    esac
}

# These git aliases are defined in git/config
alias gcb="git clean-branches"
alias gssp="git ssp"

# Get the name of the default (HEAD) branch for a remote repository.
# https://stackoverflow.com/a/44750379
function git.remote-head() {
    # Prints nothing (and succeeds) if the remote HEAD isn't set, so callers
    # running with `set -eo pipefail` can check for an empty result.
    git symbolic-ref --short "refs/remotes/${1:-origin}/HEAD" 2>/dev/null \
        | sed "s|${1:-origin}/||" || true
}

# Reuse existing commit message (in the case of a failed GPG signature, etc.)
# https://unix.stackexchange.com/a/590225
function git.recommit() {
    commit_msg_file="$(git rev-parse --git-dir)/COMMIT_EDITMSG"
    printf "Reusing commit message:\n---\n%s\n---\n" "$(grep -v "^#" "$commit_msg_file")"
    git commit -F "$commit_msg_file" --cleanup=strip "$@"
}
