#!/bin/bash

# https://cloud.google.com/blog/products/containers-kubernetes/kubectl-auth-changes-in-gke
export USE_GKE_GCLOUD_AUTH_PLUGIN=True

function gcp.account-select() {
    gcloud config set account \
        "$(gcloud auth list --format=json | jq --raw-output '.[].account' | fzf)"
}

function gcp.project-select() {
    gcloud config set project \
        "$(gcloud projects list --format=json | jq --raw-output '.[].projectId' | fzf)"
}

function gcp.cluster-select() {
    cluster_name=$(gcloud container clusters list --format=json \
        | jq --raw-output --exit-status '.[].name' | fzf)
    zone=$(gcloud container clusters list --format=json \
        | jq --raw-output --exit-status --arg cluster "$cluster_name" \
            '.[] | select(.name == $cluster) | .zone')
    gcloud container clusters get-credentials --zone "$zone" "$cluster_name"
}

alias gcp.unset="gcloud config unset account"
alias gcp.update="gcloud components update"
