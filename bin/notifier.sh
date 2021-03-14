#!/bin/sh

TOKEN=$BOT_TOKEN
ID=$CHAT_ID
URL="https://api.telegram.org/bot$TOKEN/sendMessage"
MESSAGE=$@

curl -s -X POST $URL -d chat_id=$ID -d text="$@" > /dev/null 2>&1
