#!/bin/bash

NUMLOOP="$1"

echo "Loop = ${NUMLOOP}"
for (( i = 0; i <= $NUMLOOP; i++ ))
do

        docker run -d nginx:latest &
        sleep 1
        docker run -d tomcat:latest &
        sleep 1
        docker run -d traefik:latest &
        sleep 1
done

