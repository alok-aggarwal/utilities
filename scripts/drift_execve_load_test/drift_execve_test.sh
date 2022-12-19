#!/bin/bash

# in another terminal you can collect agent memory usage
# watch -n 1 'ps -eo pid,vsz,rss,comm|grep datacollector | tee -a /tmp/agent-mem-log17.txt'

#Prerequisites: 
#install ab tool - yum install httpd-tools, apt-get install apache2-utils -y
#update local_ip_addr with ip addr of your eth0 or ens
#install docker
#agent installed, config file present

#make the script handle SIGINT
trap "echo; exit" INT

if [[ ${UID} -ne 0 ]]
then
 echo "Please run as root"
 exit 1
fi
set -x

SCRIPT_DIR=$(pwd)

#stop all containers except agent ones
./stop_containers.sh

#stop agent if running
AGENT=$(ps -ef | grep -e 'draios/bin/dragent' | grep -v "grep" |head -1 | awk '{print $2}')
kill -2 $AGENT
sleep 5s

#remove agent logs file
rm /home/alok/workspace/artifactory/draios/logs/draios.*


echo "Running test"

#cleanup
sleep 1s

echo "Num Containers = $(docker ps | wc -l)"

#start agent
/home/alok/workspace/artifactory/draios/bin/dragent > /tmp/output.txt 2>&1  &

sleep 45s

AGENT=$(ps -ef | grep -e 'draios/bin/dragent' | grep -v "grep" |head -1 | awk '{print $2}')


echo "Recycling containers"
./container_recycle.sh



echo "sleeping..."
sleep 10s
#stop agent
kill -2 $AGENT

DATE=$(date '+%F_%H-%M-%S')
cd /home/alok/utils/alpaca

python3 alpaca.py --logfile=/home/alok/workspace/artifactory/draios/logs/draios.log

STATS_DIR=/home/alok/agent_stats
mkdir -p "${STATS_DIR}/${DATE}"

mv res/*.csv "${STATS_DIR}/${DATE}"
cd ${STATS_DIR}
tar -zcvf ${DATE}.zip ${DATE}

cd ${SCRIPT_DIR}
