#!/bin/bash


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


#apt update -y
#apt install python3-pip -y
#pip3 install psrecord
#apt-get install apache2-utils -y

function stop_all_cont {
	stop_list=$(docker ps -aq)
	#stop all containrs
	docker stop $stop_list
	#remove all containers
	docker rm $stop_list
}

stop_all_cont

#remove agent_usage file
rm -rf agent_usage.txt

rm -rf strace_out*

rm -rf mem_test_stats.txt

rm -rf cpu_stats.txt

echo "Stopping datacollector.service"

sudo systemctl stop datacollector.service
sudo rm /var/log/lacework/datacollector.log

rm -rf /var/lib/lacework/profiler

echo "Running test"

#cleanup
sleep 10


sleep 5s

#echo "Num Containers = $(docker ps | wc -l)"

sudo systemctl start datacollector.service

sleep 20s

COLLECTOR=$(ps -ef | grep -e 'datacollector.*r=collector' | grep -v grep | awk '{print $2}')

ps -ef | grep datacollector

# make sure collector is running
ps -ef | grep -q '/var/lib/lacework/datacollector -r=collector'
if [ $? -eq 1 ]
then
        echo "Agent1 failed to start, aborting test"
        exit 1
fi


#psrecord
psrecord $COLLECTOR --interval 3 --log agent_usage.txt --duration 4700 --include-children &

sleep 5s

sar -u 30  >> cpu_stats.txt &
for (( i = 0; i <= 10; i++ ))
do

	#start 60 containers
	./start_containers.sh 20
	echo "Num Containers = $(docker ps | wc -l)"
        sleep 2m
	stop_all_cont
	echo "Num Containers = $(docker ps | wc -l)"
	sleep 2m
done

#strace
#strace -ffttT -o ./strace_out -p $COLLECTOR &

#echo "Printing readbytes..."
#for (( i = 0; i <= 1000; i++ ))
#do
#	./collect_stats.sh ${DOCKERD} ${COLLECTOR} >> coveo_test_stats.txt
#        echo "Sleeping..."
#        sleep 30s
#done


sleep 180m
#service datacollector stop

