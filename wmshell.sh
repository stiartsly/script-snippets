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
SRV=local
SSL=false

while [ x"$1" != x ]; do
case $1 in
    "-u")
        shift
        USR=$1
        ;;
    "-r")
        SRV=remote
        ;;
    "-s")
        SSL=true
        ;;
    *)
        echo "Usage: $0 [-r|-l|-s] -u username"
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

case ${SRV} in
    local)
        SERVER_HOST="192.168.3.182"
        TRUSTSTORE="../certs/whisper.pem"
        ;;
    remote)
        SERVER_HOST="104.156.238.116"
        TRUSTSTORE="whisper.pem"
        ;;
    *)
        echo "Error: Unknown server type $SRV"
        exit 1;;
esac

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

export ${LD_ENV}=${HOME}/workspace/wicore5.0/build/_dist/${HOST}-x86_64/debug/lib

APPID="7sRQjDsniyuHdZ9zsQU9DZbMLtQGLBWZ78yHWgjPpTKm" 
APPKEY="6tzPPAgSACJdScX79wuzMNPQTWkRLZ4qEdhLcZU6q4B9" \
API_SERVER_URL="${URL_PREFIX}${SERVER_HOST}:${API_SERVER_PORT}/web/api"
MQTT_SERVER_URI="${URI_PREFIX}${SERVER_HOST}:${MQTT_SERVER_PORT}"

./wmshell \
    --login="${LOGIN}" \
    --password="password" \
    --appid=${APPID} \
    --appkey=${APPKEY} \
    --apiserver="${API_SERVER_URL}" \
    --mqttserver="${MQTT_SERVER_URI}" \
    --apiserver="${API_SERVER_URL}" \
    --mqttserver="${MQTT_SERVER_URI}" \
    --truststore="${TRUSTSTORE}" \
    --logleve=4 \
    --deviceid="linux-platform-${USR}-${SRV}" \
    --data-location="${PWD}/${USR}-${SRV}" \
    --logfile=${PWD}/${USR}-${SRV}.log

