#!/bin/sh

#kill moquette
echo "moquette stopping"
#ps aux | grep -ie moquette | awk '{print $2}' | xargs kill -9 
ps aux | grep -ie moquette | awk '{print $2}'
echo "moquette stopped"

cd /opt/moquette &&
   rm -rf * &&
       tar -xzvf ~/deps/distribution-0.8.1-bundle-tar.tar.gz &&
          cd bin &&
              ./moquette.sh &

