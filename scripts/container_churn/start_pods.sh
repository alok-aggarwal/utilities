#!/bin/bash

NUMLOOP="$1"

echo "Loop = ${NUMLOOP}"
for (( i = 0; i < $NUMLOOP; i++ ))
do
	NAME=nginx$i
        kubectl run ${NAME} --image=nginx
done
