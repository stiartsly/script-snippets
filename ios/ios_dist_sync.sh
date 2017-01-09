#!/bin/sh

DST_TOP_DIR="../../ios/ManagedWhisper"
SRC_DIR=./_dist
DST_DIR=${DST_TOP_DIR}/NativeDistribution

if [ ! -d "${DST_TOP_DIR}" ]; then
    echo "Error, script should run in wicore5.0/build directory"
    exit 1
fi

if [ x = y ]; then
CMD="./ios_build.sh whisper"
for m in arm arm64 x86_64; do
    $CMD clean
    $CMD
done
fi

update_library() {
    for lib in cjson crypto ssl neon paho-mqtt3cs z pj pjlib-util pjnath pjmedia sodium wmcommon wmcore wmsession wmportforwarding ; do
        echo "Copying library $lib to $2"
        cp -f $1/lib$lib.a $2/. 
    done
    echo ""
}

update_headers() {
    for h in whisper.h whisper_ext.h whisper_portforwarding.h; do
        echo "Copying header $h to $2"
        cp -f $1/$h $2/.
    done
    echo ""
}

update_headers ${SRC_DIR}/iOS-arm/debug/include ${DST_DIR}/include
update_library ${SRC_DIR}/lipo/debug ${DST_DIR}/libs
