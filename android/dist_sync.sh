#!/bin/sh

DST_TOP_DIR=../../WhisperManagedCore-Android
SRC_DIR=./_dist
DST_DIR=${DST_TOP_DIR}/app/distribution/libs

if [ ! -d "${DST_TOP_DIR}" ]; then
    echo "Error, script should run in wicore5.0/build directory"
    exit 1
fi

CMD="./android_build.sh whisper"
for m in arm arm64 x86 x86_64 mips; do
    $CMD clean
    $CMD
done

update_libwhisper() {
    echo "coping libwhisper.a to $2"
    cp -f $1/libwhisper.a $2/.
    cd $2 && ls -la libwhisper.a && cd - 
    echo ""
}

for arch in arm arm64 x86 x86_64; do
    case $arch in
        arm)
            update_libwhisper ${SRC_DIR}/Android-${arch}/lib ${DST_DIR}/armeabi
            update_libwhisper ${SRC_DIR}/Android-${arch}/lib ${DST_DIR}/armeabi-v7a
            ;;
        arm64)
            update_libwhisper ${SRC_DIR}/Android-${arch}/lib ${DST_DIR}/arm64-v8a
            ;;
        x86 | x86_64)
            update_libwhisper ${SRC_DIR}/Android-${arch}/lib ${DST_DIR}/${arch}
            ;;
    esac
done
exit 0

