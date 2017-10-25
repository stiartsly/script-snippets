#!/bin/sh

case "$(uname -s)" in
    "Darwin")
        LD_ENV=DYLD_LIBRARY_PATH
        HOST=Darwin
        ;;
    "Linux")
        LD_ENV=LD_LIBRARY_PATH
        HOST=Linux
        ;;
    *)
        echo "Error: Unsupported platform"
        exit 1;;
esac

USR=stiartsly
SSL=true

while [ x"$1" != x ]; do
case $1 in
    "-u")
        shift
        USR=$1
        ;;
    "-s")
        SSL=true
        ;;
    *)
        echo "Usage: $0 [-s] -u username"
        echo "username: xu | stiartsly"
        echo ""
        exit 1;;
esac
    shift
done

case $USR in
    "stiartsly")
        LOGIN="stiartsly@gmail.com"
        ;;
    xu)
	LOGIN="xu.kunyu@kortide.com"
	;;
    *)
        echo "Error: Invalid usrID"
        exit 1;;
esac

SERVER_HOST=whisper.freeddns.org
TRUSTSTORE="../../certs/whisper.pem"

case ${SSL} in
    false)
        API_SERVER_PORT=8080
        MQTT_SERVER_PORT=1883
        URL_PREFIX="http://"
        URI_PREFIX="tcp://"        
        ;;
    true)
        API_SERVER_PORT=8443
        MQTT_SERVER_PORT=8883
        URL_PREFIX="https://"
        URI_PREFIX="ssl://"
        ;;
     *)
        echo "Error: Unknown url format $SSL"
        exit 1;;
esac

export ${LD_ENV}=${HOME}/Projects/xian/whisper/build/_dist/${HOST}-x86_64/vanilla/debug/lib

APPID="7sRQjDsniyuHdZ9zsQU9DZbMLtQGLBWZ78yHWgjPpTKm" 
APPKEY="6tzPPAgSACJdScX79wuzMNPQTWkRLZ4qEdhLcZU6q4B9" \
API_SERVER_URL="${URL_PREFIX}${SERVER_HOST}:${API_SERVER_PORT}/web/api"
MQTT_SERVER_URI="${URI_PREFIX}${SERVER_HOST}:${MQTT_SERVER_PORT}"

./wshell \
    --login="${LOGIN}" \
    --password="password" \
    --appid=${APPID} \
    --appkey=${APPKEY} \
    --apiserver="${API_SERVER_URL}" \
    --mqttserver="${MQTT_SERVER_URI}" \
    --truststore="${TRUSTSTORE}" \
    --logleve=7 \
    --deviceid="linux-platform-${USR}" \
    --data-location="${PWD}/${USR}" \
    --logfile=${PWD}/${USR}.log

