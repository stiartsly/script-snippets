#!/bin/sh

build_ios_dist() {
    CMD="./ios_build.sh whisper"
    for m in arm arm64 x86_64; do
        ${CMD} $m source-clean
        ${CMD} $m
    done
}

drop_dist_headers() {
    FILES="whisper.h whisper_ext.h whisper_portforwarding.h"

    for f in ${FILES}; do
        echo "Copying header $f from $1 to $2"
        cp -f $1/$f $2
    done
    echo ""
}

drop_dist_libs() {
    LIBS1="cjson crypto ssl neon paho-mqtt3cs z sodium"
    LIBS2="pj pjlib-util pjnath pjmedia"
    LIBS3="wmcommon wmcore wmsession wmportforwarding"

    for lib in ${LIBS1} ${LIBS2} ${LIBS3}; do
        echo "Copying library ${lib} from $1 to $2"
        cp -f $1/lib${lib}.a $2/.
    done
    echo ""
}

BINDING_PATH="../../ios/ManagedWhisper"
DEST_PATH="${BINDING_PATH}/NativeDistribution"
SOURCE_PATH="./_dist"

if [ ! -d ${SOURCE_PATH} ]; then
    echo "Error: This script should run in wicore5.0/build environ"
    exit 1
fi

while [ x"$1" != x ]; do
case $1 in
    "-path")
        shift
        BINDING_PATH=$1
        shift;;
    *)
        echo "Usage: $0 -path PATH"
        echo ""
        exit 1;;
esac
done

if [ ! -d ${BINDING_PATH} ]; then
    echo "Error: This script should run related with iOS bindings environ"
    exit 1
fi

if [ ! -e ${DEST_PATH} ]; then
    for d in "include libs"; do
        mkdir -p ${DEST_PATH}/$d
    done
fi

#build_ios_dist

drop_dist_headers ${SOURCE_PATH}/iOS-arm/debug/include ${DEST_PATH}/include
drop_dist_libs ${SOURCE_PATH}/lipo/debug ${DEST_PATH}/libs

exit 0
