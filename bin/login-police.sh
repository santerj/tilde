#!/bin/sh

host=$(hostname --fqdn)
date=$(date +"%a %F %T %Z")

if [ "$PAM_TYPE" != "close_session" ]; then
    host="`hostname`"
    notification="New login: $PAM_USER from $PAM_RHOST on $host at $date"
    /usr/local/bin/notifier.sh "$notification"
fi
