#!/bin/bash

alias k=kubectl
alias kc=kubectx

alias kd="kubectl describe"
alias kdp="kubectl describe pod"

alias kdelp="kubectl delete pod"

alias kg="kubectl get"
alias kga="kubectl get all"
alias kge="kubectl get events"
alias kgn="kubectl get namespaces"
alias kgno="kubectl get nodes"
alias kgp="kubectl get pods"

alias kunset="kubectl config unset current-context"

function kn() {
    NAMESPACE=${1:-$(kubectl get namespaces | fzf | awk '{print $1}')}
    kubectl config set-context --current --namespace="$NAMESPACE"
}

alias k.nodeinfo="k get nodes -o=custom-columns=LAUNCH:.metadata.creationTimestamp,NAME:.metadata.name,VERSION:.status.nodeInfo.kubeletVersion --sort-by=.metadata.creationTimestamp"

# https://github.com/jarpy/bin/blob/master/kpodnode
function k.podnode() {
    kubectl get pod $1 -o json | jq -r .spec.nodeName
}
