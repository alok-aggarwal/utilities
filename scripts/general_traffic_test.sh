#!/bin/bash

# in another terminal you can collect agent memory usage
# watch -n 1 'ps -eo pid,vsz,rss,comm|grep datacollector | tee -a /tmp/agent-mem-log17.txt'

#Prerequisites: 
#install ab tool - yum install httpd-tools, apt-get install apache2-utils -y
#update local_ip_addr with ip addr of your eth0 or ens
#install docker
#agent installed, config file present
if [[ ${UID} -ne 0 ]]
then
 echo "Please run as root"
 exit 1
fi
set -x

#Uncomment below for the first time install psrecord & ab tool for ubuntu
#apt update -y
#apt install python3-pip -y
#pip3 install psrecord
#apt-get install apache2-utils -y


local_ip_addr="0.0.0.0"

traffic_dir="/home/ubuntu/utils/traffic"

echo "Stopping datacollector.service"

sudo systemctl stop datacollector.service
sudo rm /var/log/lacework/datacollector.log


echo "Running test"

#cleanup
sleep 30

sudo systemctl start datacollector.service

sleep 30s

ps -ef | grep datacollector

# make sure collector is running
ps -ef | grep -q '/var/lib/lacework/datacollector -r=collector'
if [ $? -eq 1 ]
then
        echo "Agent1 failed to start, aborting test"
        exit 1
fi

sleep 10s

#docker run nginx &
#docker run redis &
docker run -dit --log-opt max-size=10m --name docker0 -p 8080:80 httpd:2.4 &

#su john; exit;
#su david; exit;

for i in {1..20}
do

        sudo "$traffic_dir"/megacrawler.sh "$traffic_dir"/hundredDomains.txt
        sleep 5
	#-c concurrency. Number of multiple requests to perform at a time. Default is one request at a time.
	#-n requests Number of requests to perform for the benchmarking session. The default is to just perform a single request which usually leads to non-representative benchmarking results.
        ab -k -c 1000 -n 100000 http://$local_ip_addr:8080/
        sleep 5s

done

sleep 30m

