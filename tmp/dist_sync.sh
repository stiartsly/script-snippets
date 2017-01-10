#!/bin/sh

binding_ios_path() {
    $1 = "../../ios/ManagedWhisper"
    $2 = "$1/NativeDistribution"
}

binding_android_path() {
    $1 = "../../WhisperManagedCore-Android"
    $2 = "$1/app/distribution"
}

build_ios_dist() {
    CMD="./ios_build.sh whisper"
    for m in arm arm64 x86_64; do
        ${CMD} $m source-clean
        ${CMD} $m
    done
}

build_android_dist() {
    CMD="./android_build.sh whisper"
    for m in arm arm64 x86 x86_64 mips; do
        ${CMD} $m source-clean
        ${CMD} $m
    done
}

drop_dist_headers() {
    FILES="whisper.h whisper_ext.h whisper_portforwarding.h"
    for f in ${FILES}; do
        echo "Copying header $f from ${SRC_PATH} to ${DEST_PATH}"
        cp -f ${SRC_PATH}/$f ${DEST_PATH}
    done
    echo ""
}

update_library() {
    for lib in cjson crypto ssl neon paho-mqtt3cs z pj pjlib-util pjnath pjmedia sodium wmcommon wmcore wmsession wmportforwarding ; do
        echo "Copying library $lib to $2"
        cp -f $1/lib$lib.a $2/. 
    done
    echo ""
}

DST_TOP_DIR="../../ios/ManagedWhisper"
DST_DIR=${DST_TOP_DIR}/NativeDistribution
SRC_DIR=./_dist
BINDING=android
BINDING_PATH=
DEST_PATH=
SRC_PATH=

while [ x"$1" != x ]; do
case $1 in
    "-ios")
        BINDING=ios
        ;;
    "-android")
        BINDING=android
        ;;
    "-path")
        shift
        BINDING_PATH=$1
        ;;
    *)
        echo "Error: unknown parameter $1"
        echo "Usage: $0 [ -ios | -android ] -path PATH"
        exit 1;;
easc
    shift
done

if [ -z ${BINDING_PATH} ]; then
    case ${BINDING} in
        ios)
            binding_ios_path ${BIDING_PATH} ${DEST_PATH} 
            ;;
        android)
            bind_android_path ${BINDING_PATH} ${DEST_PATH}
            ;;
        *)
            echo "Error: Unsupported binding type ${BINDING}"
            exit 1;;
    esac    
fi

case ${BINDING} in
    ios)
        build_ios_dist 
        ;;
    android)
        build_android_dist
        ;;
    *)
        echo "Error: Unsupported binding type ${BINDING}"
        exit 1;;
esac

update_headers ${SRC_DIR}/iOS-arm/debug/include ${DST_DIR}/include
update_library ${SRC_DIR}/lipo/debug ${DST_DIR}/libs

