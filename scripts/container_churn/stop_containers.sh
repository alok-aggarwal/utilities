#!/bin/bash

stop_list=$(docker ps -aq)
#stop all containrs
docker stop $stop_list
#remove all containers
docker rm $stop_list

