#!/bin/bash

NUMLOOP="$1"

echo "Loop = ${NUMLOOP}"
for (( i = 1; i <= $NUMLOOP; i++ ))
do

        docker run -d aloklw/running_ubuntu_execves &
        sleep 1
done

