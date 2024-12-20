#!/bin/bash

function gpg.init() {
    gpgconf --kill gpg-agent

    # https://www.gnupg.org/documentation/manuals/gnupg/Common-Problems.html
    GPG_TTY=$(tty)
    export GPG_TTY

    # https://stackoverflow.com/a/57579018
    GPG_AGENT_INFO=$(gpgconf --list-dirs agent-socket | tr -d '\n' && echo -n ::)
    export GPG_AGENT_INFO
}

function gpg.export-to-sign() {
    KEYID=$1
    gpg -a --export "${KEYID}" >"${KEYID}_unsigned.asc"
}

function gpg.export-signed-uids() {
    KEYID=$1
    IFS=$'\n\t'
    for uid in $(gpg -k "${KEYID}" | rg uid | sd ".*] " ""); do
        # shellcheck disable=SC2016
        email=$(echo "${uid}" | sd '.*<(?P<addr>.+)>' '$addr')
        emailescaped=$(echo "${email}" | sd -s '@' '_at_')
        # Export a copy of the key containing only the signature for one UID,
        # then encrypt it using the key associated with that UID's email.
        gpg -q --armor --export --export-filter keep-uid="uid = ${uid}" "${KEYID}" \
            | gpg -se -r "${email}" >"${KEYID}_${emailescaped}.asc.gpg"

        # Save an unencrypted copy to inspect
        # gpg -q --armor --export --export-filter keep-uid="uid = ${uid}" "${KEYID}" >"${KEYID}_${emailescaped}.asc"
    done
}

function gpg.decrypt-signature-commands() {
    # Print out the commands to import the files created by the export above,
    # and then publish the new public keys containing the signature.
    FILENAME=$1
    KEYID=$(echo "${FILENAME}" | sd "_.*" "")
    echo "gpg --decrypt ${FILENAME} | gpg --import"
    echo "gpg --send-keys ${KEYID}"
}
