#!/bin/bash
config() {
    NEW="$1"
    OLD="`dirname $NEW`/`basename $NEW .new`"
    # If there's no config file by that name, mv it over:
    if [ ! -r $OLD ]; then
        mv $NEW $OLD
    elif [ "`cat $OLD | md5sum`" = "`cat $NEW | md5sum`" ]; then # toss the redundant copy
        rm $NEW
    fi
    # Otherwise, we leave the .new copy for the admin to consider...
}

configdel() {
    NEW="$1"
    OLD="`dirname $NEW`/`basename $NEW .new`"
    # If there's no config file by that name, mv it over:
    if [ ! -r $OLD ]; then
        mv $NEW $OLD
    else
        rm $NEW
    fi
}

system_group() {
    # Create the group ($1) as very low-ID system accounts, if it doesn't exist.
    if ! getent group "$1" >/dev/null 2>&1; then
        local I=1
        while ! groupadd -g $I "$1" 2>/dev/null; do
            I=$((I + 1))
        done
    fi
}
