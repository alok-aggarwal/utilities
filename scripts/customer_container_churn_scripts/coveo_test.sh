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


#apt update -y
#apt install python3-pip -y
#pip3 install psrecord
#apt-get install apache2-utils -y


#To delete all containers including its volumes use,

#docker rm -vf $(docker ps -a -q)
#To delete all the images,

#docker rmi -f $(docker images -a -q)

stop_list=$(docker ps -aq)
#stop all containrs
docker stop $stop_list
#remove all containers
docker rm $stop_list

#remove agent_usage file
rm -rf agent_usage.txt

rm -rf strace_out*

rm -rf coveo_test_stats.txt

rm -rf cpu_stats.txt

echo "Stopping datacollector.service"

sudo systemctl stop datacollector.service
sudo rm /var/log/lacework/datacollector.log


#start 100 containers
./start_containers.sh 33


echo "Running test"

#cleanup
sleep 10


sleep 5s

echo "Num Containers = $(docker ps | wc -l)"

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

DOCKERD=$(ps -ef | grep -e 'dockerd' | grep -v grep | awk '{print $2}')

#psrecord
#psrecord $COLLECTOR --interval 3 --log agent_usage.txt --duration 12000 --include-children &

sleep 5s


#start killer in another terminal
#./killer.sh &
echo "start killer in another terminal now"

#sleep 15m

#add 15 containers
#./start_containers.sh 5

#sleep 70m
#on m5 large with 200 containers it takes 75 mins for machine to stop
for (( i = 0; i <= 100; i++ ))
do

      	echo "Sleeping..."
        sleep 1m
done

#strace
#strace -ffttT -o ./strace_out -p $COLLECTOR &

echo "Printing readbytes..."
sar -u 30  >> cpu_stats.txt &
for (( i = 0; i <= 1000; i++ ))
do
	./collect_stats.sh ${DOCKERD} ${COLLECTOR} >> coveo_test_stats.txt
        echo "Sleeping..."
        sleep 30s
done


#Collect periodic cpu profile
#for (( i = 0; i <= 12; i++ ))
#do

#	echo "Alive..."
#        kill -SIGQUIT $COLLECTOR
#	sleep 15m
#done

#Move profiler output files
DATE=$(date +%d)
#mv /var/lib/lacework/profiler /home/alok
#mv /home/alok/profiler /home/alok/profiler_${DATE}
#chmod 666 /home/alok/profiler_${DATE}


sleep 180m
#service datacollector stop

