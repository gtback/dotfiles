#!/bin/bash

### Git aliases
alias branch='git symbolic-ref --short HEAD'
alias ga='git add'
alias gb='git branch'
alias gba='git branch --all'
alias gbac='git branch --all --contains'
alias gbc='git branch --contains'
alias gc='git commit'
alias gco='git checkout'
alias gd='git diff'
alias gdca='git diff --cached'
alias gfa='git fetch --all'
alias glg='git lg'
alias gls='git log --stat'
alias glsig='git log --show-signature'
alias gm='git merge'
alias gpso='git push --set-upstream origin'
alias grv='git remote -v'
alias gsd='git stash drop'
alias gsl='git stash list'
alias gst='git status'

# Run a `diff` that doesn't use `delta` as the pager, meaning the output can be
# pasted directly into GitHub, etc.
alias g.diff='git -c core.pager= diff'

function b() {
    # Can use `b --all` to include remote branches or `b --verbose` to show commit messages, or combine multiple args
    git checkout "$(git --no-pager branch --no-color "$@" | grep -v '\*' | sed 's/^[[:space:]]*//' | fzf | awk '{print $1}')"
}

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

# These git aliases are defined in _gitconfig
alias gcb="git clean-branches"
alias gpom="git pom"
alias gssp="git ssp"

# This function exists, with slight modifications and variations, all over
# GitHub. I initially a version modified by @Crazybus at:
# https://github.com/Crazybus/dotfiles/blob/4f20e69420e76cdf268017170ac92969a5b7a23f/zshrcfunctions
#
# The original version seems to be in this gist:
# https://gist.github.com/tamphh/3c9a4aa07ef21232624bacb4b3f3c580, which comes
# from the same user's dotfiles:
# https://github.com/tamphh/dotfiles/blob/17572f973fdef98c982e7c79b39914b2c39fe377/shell/zsh/git.zsh
#
# This version uses `--pickaxe-regex -S`, which searches for commits that change
# the number of occurences of the specified string (as a regular expression) in
# a file (meaning it was added or removed).
#
# The original version (`gli`) was used to browse the history of a repo, or of a specific with FZF
function git-log-regex() {
    local filter=
    # local filter="-- $@"  # enable to restrict to a specific path
    local pattern=${1:-'.*'}
    local gitlog=(git log --color=always --abbrev=7 --format='%C(auto)%h %C(yellow)%ad %an %C(blue) %s' --date=short --pickaxe-regex -S "$pattern" ./)
    local fzf=(fzf --ansi --no-sort --reverse --tiebreak=index --preview "f() { set -- \$(echo -- \$@ | grep -o '[a-f0-9]\{7\}'); [ \$# -eq 0 ] || git show --color=always \$1 $filter; }; f {}" --bind "ctrl-q:abort,ctrl-m:execute:
        (grep -o '[a-f0-9]\{7\}' | head -1 |
        xargs -I % sh -c 'git show --color=always % $filter | less -R') << 'FZF-EOF'
        {}
        FZF-EOF" --preview-window=right:60%)
    "${gitlog[@]}" | rg -v "Merge Pull Request" | "${fzf[@]}"
}
alias glr='git-log-regex'

function gc.with() {
    local who=$1
    shift
    git commit --trailer "$(git.coauthor "$who")" "$@"
}

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
