#!/bin/bash
DOCKERD="$1"
COLLECTOR="$2"

echo " "
echo "stats......."
date
echo "Dockerd"
cat /proc/${DOCKERD}/io | grep read_bytes
ps -o min_flt,maj_flt ${DOCKERD}
echo "Collector"
cat /proc/${COLLECTOR}/io | grep read_bytes
ps -o min_flt,maj_flt ${COLLECTOR}
echo "PID1"
grep pgfault /proc/vmstat
ps -o min_flt,maj_flt 1
free
#mpstat


