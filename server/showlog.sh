#!/bin/sh

show_help() {
    echo "Usage: $0 [-hmwc]"
    echo "Options:"
    echo "\t-h show this help information"
    echo "\t-m show moquette running log"
    echo "\t-w show whisper api server log"
    echo "\t-c show whisper core server log"
    echo ""
}

if [ "$#" -lt 1 ]; then
    show_help
    exit 1
fi

OPTIND=1

while getopts "hmwc" opt; do
    case "$opt" in
    h)
        show_help
        exit 0;;
    m)
        tail -n 20 /opt/moquette/bin/moquette.log
        ;;
    w)
        tail -n 20 /var/log/tomcat8/whisper_web_*.log
        ;;
    c)
        tail -n 20 /var/log/tomcat8/whisper_core_*.log
        ;;
    *)
        echo "Invalid arguments"
        show_help
        exit 1;;
    esac
done
exit 0

