#!/bin/sh

LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:../../build/_dist/Linux-x86_64/debug/lib" &&
./wmshell --login="stiartsly@gmail.com" \
	--password="password" \
	--appid="7sRQjDsniyuHdZ9zsQU9DZbMLtQGLBWZ78yHWgjPpTKm" \
	--appkey="6tzPPAgSACJdScX79wuzMNPQTWkRLZ4qEdhLcZU6q4B9" \
	--apiserver="http://104.156.238.116:8080/web/api" \
	--mqttserver="tcp://104.156.238.116:1883" \
	--logleve=3

