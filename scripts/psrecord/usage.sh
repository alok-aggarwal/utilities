#!/bin/bash
#run as root
if [[ ${UID} -ne 0 ]]
then
 echo "Please run as root"
 exit 1
fi

apt update -y
apt install python3-pip -y
pip3 install psrecord


sleep 5

sudo systemctl start datacollector.service

sleep 10

COLLECTOR=$(ps -ef | grep -e 'datacollector.*r=collector' | grep -v grep | awk '{print $2}')

sleep 5

NSHELPER=$(ps -ef | grep -e 'datacollector.*mnt' | grep -v grep | awk '{print $2}')

echo $COLLECTOR
echo $NSHELPER


ps -ef | grep datacollector

# make sure collector/nshelper is running
ps -ef | grep -q 'collector'
if [ $? -eq 1 ]
then
        echo "Agent failed to start, aborting test"
        exit 1
fi

ps -ef | grep -q 'mnt'
if [ $? -eq 1 ]
then
        echo "nshelper failed to start, aborting test"
#        exit 1
fi

psrecord $COLLECTOR --interval 3 --log agent_usage.txt --duration 4200 --include-children &

#psrecord $NSHELPER --interval 3 --log nshelper_usage.txt --duration 4200 &

psrecord $COLLECTOR --interval 3 --log collector_usage.txt --duration 4200 &
sleep 4220



sudo systemctl stop datacollector.service

