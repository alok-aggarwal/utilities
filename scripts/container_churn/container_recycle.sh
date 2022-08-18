#!/bin/bash

echo "cleaning up containers..."
./stop_containers.sh

sleep 15s

for (( i = 1; i <= 10; i++ ))
do


	#start 45 containers
	./start_containers.sh 15


	echo "Sleeping for 2 mins after starting the containers"

	#cleanup
	sleep 120s


	echo "Num Containers = $(docker ps | wc -l)"

        sleep 5s
        echo "Stopping containers..."
	./stop_containers.sh

	echo "Sleeping for 4 mins after stopping containers"
	sleep 240s


done


