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
alias glg='git log --stat'
alias gls='git log --show-signature'
alias gm='git merge'
alias gpso='git push --set-upstream origin'
alias grv='git remote -v'
alias gsd='git stash drop'
alias gsl='git stash list'
alias gst='git status'

function b() {
    # Can use `b --all` to include remote branches or `b --verbose` to show commit messages, or combine multiple args
    git checkout "$(git --no-pager branch --no-color "$@" | grep -v '\*' | sed 's/^[[:space:]]*//' | fzf | awk '{print $1}')"
}

function gcm() {
    git stash save
    git checkout main 2>/dev/null || git checkout master
    git stash pop
}

# These git aliases are defined in _gitconfig
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
    # local filter
    # if [ -n $@ ] && [ -f $@ ]
    # then
    #     filter="-- $@"
    # fi
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
