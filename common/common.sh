#!/bin/bash
#
# Common SlackBuild functions

die() {
    echo "$@.  Exiting."
    exit 1
}

slackbuild_init() {
    CWD=`pwd`
    TMP=${TMP:-/tmp}
    if [ ! -d $TMP ]; then
        mkdir -p $TMP
    fi
    PKG=$TMP/package-${NAME}
    rm -rf $PKG
    mkdir -p $PKG

    # Set the CPU count to CPUs + 1.
    CPUCOUNT=$((`nproc`+1))
}

# URL is in $1
# Optional filename to save to is $2.
slackbuild_download() {
    local CMD="wget -N -c "
    [[ -n "$2" ]] && CMD+="-O '$2' "
    CMD+="'$1'"

    eval $CMD
}

# Sets sane permissions for the unpacked files.
slackbuild_setpkgperms() {
    # Make sure we're not about to wreck something.
    [[ "$(pwd)" =~ ^/tmp/ ]] || die "slackbuild_setpkgperms: must be in subdirectory of /tmp."

    chown -R root.root .
    find . -perm 777 -exec chmod 755 {} \;
    find . -perm 775 -exec chmod 755 {} \;
    find . -perm 666 -exec chmod 644 {} \;
    find . -perm 664 -exec chmod 644 {} \;
    find . -perm 444 -exec chmod 644 {} \;
}

slackbuild_build() {
    cd $PKG
    makepkg -l y -c n $TMP/${NAME}-${VERSION}-${ARCH}-${BUILD}.txz
}

# For the package in $1, get the md5sum and extract just the checksum to stdout.
slackbuild_get_md5sum() {
    local OUT=$(md5sum $1)
    echo $OUT | cut -d' ' -f1
}