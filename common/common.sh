#!/bin/bash
#
# Common SlackBuild functions

slackbuild_init() {
    CWD=`pwd`
    TMP=${TMP:-/tmp}
    if [ ! -d $TMP ]; then
        mkdir -p $TMP
    fi
    PKG=$TMP/package-${NAME}
    rm -rf $PKG
    mkdir -p $PKG
}

# URL is in $1
# Optional filename to save to is $2.
slackbuild_download() {
    local CMD="wget -N -c "
    [[ -n "$2" ]] && CMD+="-o '$2' "
    CMD+="'$1'"

    eval $CMD
}
