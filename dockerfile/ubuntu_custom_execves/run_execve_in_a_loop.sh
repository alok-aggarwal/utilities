#!/bin/bash

#tell script to exit on SIGINT (ctrl+c)
trap "echo; exit" INT
PREFIX="timeout 1 "
#allow agent to parse container mounts
sleep 5s
while true
do
	sleep 0.1
	/bin/do_nothing
	sleep 0.1
	/usr/bin/do_nothing
done

