#!/bin/bash

# in another terminal you can collect agent memory usage
# watch -n 1 'ps -eo pid,vsz,rss,comm|grep datacollector | tee -a /tmp/agent-mem-log17.txt'

set -x


traffic_dir="/home/centos/utils/traffic"
agent1_dir="/var/lib/lacework"
agent2_dir="/var/lib/lacework2"
agent1_log_dir="/var/log/lacework"
agent2_log_dir="/var/log/lacework2"

COLLECTOR=$(ps -ef | awk '$8=="/var/lib/lacework2/datacollector" {print $2}')
CONTROLLER=$(ps -ef | awk '$8=="./datacollector" {print $2}')

echo "Stopping datacollector.service"

sudo systemctl stop datacollector.service
sudo rm /var/log/lacework/datacollector.log

kill -9 $COLLECTOR
kill -9 $CONTROLLER
sudo rm /var/log/lacework2/datacollector.log

echo "Running test"

#cleanup
sleep 30

sudo systemctl start datacollector.service

cd $agent2_dir
./datacollector &

sleep 1m

COLLECTOR=$(ps -ef | awk '$8=="/var/lib/lacework2/datacollector" {print $2}')
CONTROLLER=$(ps -ef | awk '$8=="./datacollector" {print $2}')

echo $COLLECTOR
echo $CONTROLLER

ps -ef | grep datacollector

# make sure collector is running
ps -ef | grep -q '/var/lib/lacework/datacollector -r=collector'
if [ $? -eq 1 ]
then
        echo "Agent1 failed to start, aborting test"
        exit 1
fi

ps -ef | grep -q '/var/lib/lacework2/datacollector -r=collector'
if [ $? -eq 1 ]
then
        echo "Agent2 failed to start, aborting test"
        exit 1
fi

sleep 1m

#docker run nginx &
#docker run redis &

for i in {1..1}
do

        sudo "$traffic_dir"/megacrawler.sh "$traffic_dir"/hundredDomains.txt
        sleep 5
#        sudo tcpreplay -i ens33 "$traffic_dir"/lo.pcap
#        sleep 10

done

sleep 30m

sudo systemctl stop datacollector.service
#COLLECTOR=$(ps -ef | awk '$8=="/var/lib/lacework2/datacollector_setns" {print $2}')
#CONTROLLER=$(ps -ef | awk '$8=="./datacollector_setns" {print $2}')
kill -9 $COLLECTOR
kill -9 $CONTROLLER

#docker stop nginx
#docker stop redis

cp "$agent1_log_dir"/datacollector.log /home/centos/pkgScanContResults/datacollector.log.cont
cp "$agent2_log_dir"/datacollector.log /home/centos/pkgScanContResults/datacollector.log.binary
