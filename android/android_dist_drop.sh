#!/bin/sh

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
        echo "Copying header $f from $1 to $2"
        cp -f $1/$f $2
    done
    echo ""
}

drop_libwhisper() {
    echo "Copying library libwhisper.a from $1 to $2"
    echo ""
    cp -f $1/libwhisper.a $2/.
}

drop_dist_libs() {
    for m in arm arm64 x86 x86_64; do
        LIB_PATH=$1/Android-$m/debug/lib
        case $m in
            arm)
                drop_libwhisper ${LIB_PATH} $2/armeabi
                drop_libwhisper ${LIB_PATH} $2/armeabi-v7a
                ;;
            arm64)
                drop_libwhisper ${LIB_PATH} $2/arm64-v8a
                ;;
            x86_64 | x86)
                drop_libwhisper ${LIB_PATH} $2/$m
                ;;
        esac
    done
}

BINDING_PATH="../../WhisperManagedCore-Android"
DEST_PATH="${BINDING_PATH}/app/distribution"
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
    echo "Error: This script should run related with Android bindings environ"
    exit 1
fi

if [ ! -e ${DEST_PATH} ]; then
    for d in "include libs"; do
        mkdir -p ${DEST_PATH}/$d
    done
fi

#build_android_dist

drop_dist_headers ${SOURCE_PATH}/Android-arm/debug/include ${DEST_PATH}/include
drop_dist_libs ${SOURCE_PATH} ${DEST_PATH}/libs

exit 0

