#!/bin/sh

echo "tomcat8 stopping..."
sudo service tomcat8 stop
echo "tomcat8 stoped"

TOMCAT_DIR="/var/lib/tomcat8"

for dir in core web; do
    sudo rm -rf  ${TOMCAT_DIR}/${dir}
    sudo rm -f ${TOMCAT_DIR}/${dir}.war
    sudo cp ~/deps/${dir}.war ${TOMCAT_DIR} 
    sudo chown tomcat8:tomcat8 ${TOMCAT_DIR}/${dir}.war
done

echo "tomcat8 starting..."
sudo service tomcat8 start
echo "tomcat8 started"
