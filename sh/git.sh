#!/bin/bash

### Git aliases
alias branch='git symbolic-ref --short HEAD'
alias ga='git add'
alias gb='git branch'
alias gba='git branch --all'
alias gbac='git branch --all --contains'
alias gbc='git branch --contains'
alias gc='git commit'
alias gcm='git checkout main 2>/dev/null || git checkout master'
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

# https://medium.com/@mrWinston/smarter-git-checkout-using-fzf-to-supercharge-your-commandline-7507db600996
function b() {
    git checkout "$(git branch --all | fzf | tr -d '[:space:]')"
}

# These git aliases are defined in _gitconfig
alias gpom="git pom"
alias gssp="git ssp"
