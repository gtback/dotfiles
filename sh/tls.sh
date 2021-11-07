#!/bin/bash

function tls.dates() {
    echo | openssl s_client -servername "$1" -connect "$1":443 2>/dev/null | openssl x509 -noout -dates
}

# https://stackoverflow.com/a/59412853/1136755
function tls.seecert() {
    nslookup "$1"
    (openssl s_client -showcerts -servername "$1" -connect "$1:443" <<<"Q" | openssl x509 -noout -dates)
}
