#!/bin/sh

# First, start the container
AGENT_CONTAINER_ID=$(docker ps | grep sysdig-agent | awk '{print $1}')

# Then start watching that it's running (with inspect)
while [ "$(docker inspect -f {{.State.Running}} $AGENT_CONTAINER_ID 2>/dev/null)" = "true" ]; do
    # And while it's running, check stats
    #docker stats $CONTAINER_ID 2>&1 | tee "$1"
    docker stats --no-stream --format "table {{.Container}}\t{{.CPUPerc}}\t{{.MemUsage}}\t{{.NetIO}}\t{{.BlockIO}}\t{{.PIDs}}" $AGENT_CONTAINER_ID 2>&1
    #sleep 1
done
