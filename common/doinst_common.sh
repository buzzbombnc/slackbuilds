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

# Determine if the group "$1" exists on the system.
# Non-zero exit means no.
group_exists()
{
    getent group 2>/dev/null | egrep -qi "^${1}:"
}

# Determine if the user "$1" exists on the system.
# Non-zero exit means no.
user_exists()
{
    getent passwd 2>/dev/null | egrep -qi "^${1}:"
}

# Finds a $1 'gid', a 'uid', or 'both' (default, matching gid/uid) between LOW ($2, default 1) and HIGH ($3, default 499).
# Returns the value in stdout or non-zero for error.
find_system_gid_uid()
{
    local FIND=${1:-both}
    FIND=${FIND@L}
    [[ "$FIND" == 'gid' || "$FIND" == 'uid' || "$FIND" == 'both' ]] || return 1

    local LOW=${2:-1}
    local HIGH=${3:-499}
    local I GX UX
    for (( I=$LOW; I<=$HIGH; I++ )); do
        getent group $I >/dev/null 2>&1
        GX=$?
        getent passwd $I >/dev/null 2>&1
        UX=$?

        # Return value of the above functions is 2 when the ID is available.
        if [[ $FIND == gid && $GX -eq 2 ]] || \
            [[ $FIND == uid && $UX -eq 2 ]] || \
            [[ $FIND == both && $GX -eq 2 && $UX -eq 2 ]]; then
                echo $I
                return
        fi
    done
}
