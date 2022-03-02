#!/bin/bash

# noti: Monitor a process and trigger a notification.
# https://github.com/variadico/noti

noti.setup() {
    op.signin
    NOTI_TELEGRAM_TOKEN=$(op get item "Telegram Bot" | jq -r '.details.sections[] | select(has("fields")) | .fields[] | select(.t == "credential").v')
    export NOTI_TELEGRAM_TOKEN

    NOTI_TELEGRAM_CHATID=$(op get item "Telegram Bot" | jq -r '.details.sections[] | select(has("fields")) | .fields[] | select(.t == "chat_id").v')
    export NOTI_TELEGRAM_CHATID

    export NOTI_DEFAULT="telegram banner"
}

noti.clear() {
    for e in $(env | grep -i ^NOTI_ | awk -F'=' '{ print $1; }'); do
        echo "Unsetting $e"
        unset "$e"
    done
}
