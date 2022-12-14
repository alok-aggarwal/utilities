#!/bin/bash

echo "cleaning up containers..."
./stop_containers.sh

sleep 5s

for (( i = 1; i <= 1; i++ ))
do


	#start 5 containers
	./start_containers.sh 1


	echo "Sleeping for 5 mins after starting the containers"

	#cleanup
	sleep 300s


	echo "Num Containers = $(docker ps | wc -l)"

        sleep 2s
        echo "Stopping containers..."
	./stop_containers.sh

	echo "Sleeping for 30s min after stopping containers"
	sleep 30s


done


