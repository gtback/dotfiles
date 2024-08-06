#!/bin/bash

# noti: Monitor a process and trigger a notification.
# https://github.com/variadico/noti

noti.setup() {
    NOTI_TELEGRAM_TOKEN=$(op item get "Telegram Bot" --reveal --fields "credential")
    export NOTI_TELEGRAM_TOKEN

    NOTI_TELEGRAM_CHATID=$(op item get "Telegram Bot" --reveal --fields "chat_id")
    export NOTI_TELEGRAM_CHATID

    export NOTI_DEFAULT="telegram banner"
}

noti.clear() {
    for e in $(env | grep -i ^NOTI_ | awk -F'=' '{ print $1; }'); do
        echo "Unsetting $e"
        unset "$e"
    done
}

noti.test() {
    noti sleep 2
}
