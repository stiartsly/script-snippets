#!/bin/sh

HOST=$(uname -s)
ARCH=$(uname -m)

case ${HOST} in
    "Linux" | "Darwin")
        ;;
    *)
        echo "Error: $0 should run on Darwin/Linux"
        exit 1;;
esac

DSO_PATH="${PWD}/../../build/_dist/${HOST}-${ARCH}/vanilla/debug/lib"

if [ ! -d ${DSO_PATH} ]; then
     echo "Error: whisper library path ${DSO_PATH} not exist"
     exit 1
fi

case ${HOST} in
    "Linux")
        LD_LIBRARY_PATH="${DSO_PATH}" ./wpfd --deviceid=wpfdclient -c client.conf $*
        ;;
    "Darwin")
        DYLD_LIBRARY_PATH="${DSO_PATH}" ./wpfd --device=wpfdclient -c client.conf $*
        ;;
esac

exit 0

