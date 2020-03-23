#!/bin/bash -e
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
