#!/bin/bash

# Krew: kubectl plugin manager
# https://krew.sigs.k8s.io/

export PATH="$PATH:$KREW_ROOT/bin"

alias krew="kubectl krew"

# https://krew.sigs.k8s.io/docs/user-guide/setup/install/#bash
function krew.install() {
    (
        set -x
        cd "$(mktemp -d)" \
            && OS="$(uname | tr '[:upper:]' '[:lower:]')" \
            && ARCH="$(uname -m | sed -e 's/x86_64/amd64/' -e 's/\(arm\)\(64\)\?.*/\1\2/' -e 's/aarch64$/arm64/')" \
            && KREW="krew-${OS}_${ARCH}" \
            && curl -fsSLO "https://github.com/kubernetes-sigs/krew/releases/latest/download/${KREW}.tar.gz" \
            && tar zxvf "${KREW}.tar.gz" \
            && ./"${KREW}" install krew
    )
}

# https://krew.sigs.k8s.io/docs/user-guide/list/
function krew.freeze() {
    kubectl krew list >"${XDG_CONFIG_HOME}/krew/krew.lock"
}

function krew.sync() {
    kubectl krew install <"${XDG_CONFIG_HOME}/krew/krew.lock"
}
