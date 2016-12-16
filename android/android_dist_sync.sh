#!/bin/sh

DST_TOP_DIR=../../WhisperManagedCore-Android
SRC_DIR=./_dist
DST_DIR=${DST_TOP_DIR}/app/distribution

if [ ! -d "${DST_TOP_DIR}" ]; then
    echo "Error, script should run in wicore5.0/build directory"
    exit 1
fi

if [ x = y ]; then
CMD="./android_build.sh whisper"
for m in arm arm64 x86 x86_64 mips; do
    $CMD clean
    $CMD
done
fi

update_library() {
    echo "Copying library libwhisper.a to $2"
    cp -f $1/libwhisper.a $2/.
    echo ""
}

update_headers() {
    for h in whisper.h whisper_ext.h whisper_portforwarding.h; do
        echo "Copying header $h to $2"
        cp -f $1/$h $2/.
    done
    echo ""
}

update_headers ${SRC_DIR}/Android-arm/debug/include ${DST_DIR}/include
for arch in arm arm64 x86 x86_64; do
    case $arch in
        arm)
            update_library ${SRC_DIR}/Android-${arch}/debug/lib ${DST_DIR}/libs/armeabi
            update_library ${SRC_DIR}/Android-${arch}/debug/lib ${DST_DIR}/libs/armeabi-v7a
            ;;
        arm64)
            update_library ${SRC_DIR}/Android-${arch}/debug/lib ${DST_DIR}/libs/arm64-v8a
            ;;
        x86 | x86_64)
            update_library ${SRC_DIR}/Android-${arch}/debug/lib ${DST_DIR}/libs/${arch}
            ;;
    esac
done
exit 0

