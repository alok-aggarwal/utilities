#!/bin/bash
sleep 10m
while true
do
	kill -9 $(ps -ef | grep -e 'datacollector.*ns' | grep -v grep | grep -v mnt | awk '{print $2}')
	sleep 0.05s
 #  sleep 3
done
