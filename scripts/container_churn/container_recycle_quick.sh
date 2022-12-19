#!/bin/bash

echo "cleaning up containers..."
./stop_containers.sh

sleep 5s

for (( i = 1; i <= 2; i++ ))
do


	#start 45 containers
	./start_containers.sh 2


	echo "Sleeping for 5s after starting the containers"

	#cleanup
	sleep 5s


	echo "Num Containers = $(docker ps | wc -l)"

        sleep 5s
        echo "Stopping containers..."
	./stop_containers.sh

	echo "Sleeping for 5s after stopping containers"
	sleep 5s


done


