#!/bin/bash

#stop all containers except agent ones
stop_list=$(docker ps -a | grep -v -E "COMMAND|agent" | awk '{print $1}')
docker stop $stop_list
#remove all containers
docker rm $stop_list

