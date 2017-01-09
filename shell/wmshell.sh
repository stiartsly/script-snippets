#!/bin/sh

USR="stiartsly"
if [ x"$1" != x ]; then
    USR=$1
fi

case $USR in
    "stiartsly")
        LOGIN="stiartsly@gmail.com"
        ;;
    "xu")
	LOGIN="xu.kunyu@kortide.com"
	;;
    *)
        echo "Error: Invalid usrID !"
        exit 1 ;;
esac

case "$(uname -s)" in
    "Darwin")
        LD_ENV="DYLD_LIBRARY_PATH"
        HOST="Darwin"
        ;;
    "Linux")
        LD_ENV="LD_LIBRARY_PATH"
        HOST="Linux"
        ;;
    *)
        echo "Error: Unsupported platform"
        exit 1 ;;
esac

export ${LD_ENV}=${HOME}/workspace/wicore5.0/build/_dist/${HOST}-x86_64/debug/lib

./wmshell \
    --login="${LOGIN}" \
    --password="password" \
    --appid="7sRQjDsniyuHdZ9zsQU9DZbMLtQGLBWZ78yHWgjPpTKm" \
    --appkey="6tzPPAgSACJdScX79wuzMNPQTWkRLZ4qEdhLcZU6q4B9" \
    --apiserver="https://192.168.3.182:8443/web/api" \
    --mqttserver="ssl://192.168.3.182:8883" \
    --truststore="whisper.pem" \
    --logleve=4 \
    --deviceid="linux-platform-${USR}" \
    --data-location="${PWD}/${USR}" \
    --logfile=${PWD}/${USR}.log

