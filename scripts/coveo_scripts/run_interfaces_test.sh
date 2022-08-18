#!/bin/bash

# in another terminal you can collect agent memory usage
# watch -n 1 'ps -eo pid,vsz,rss,comm|grep datacollector | tee -a /tmp/agent-mem-log17.txt'

set -x

#intf_tests=( 50 100 150 200 250 300 )
intf_tests=( 200 )
up_down_intf=50

current_dir="$PWD"

# clean up any stall data from previous run

cleanup() {
	for f in `ip link | grep intf | cut -d : -f 2`; do sudo ip link set dev "$f" down; done
	for f in `ip link | grep intf | cut -d : -f 2`; do sudo brctl delbr $f; done
}

sudo systemctl stop datacollector.service
sudo rm /var/log/lacework/datacollector.log

mkdir intf_tests
pushd intf_tests

for number_intf in ${intf_tests[@]}
do
	echo "Running test for $number_intf interfaces"
	rm "$number_intf"
	mkdir "$number_intf"

	sudo systemctl stop datacollector.service
	sudo rm /var/log/lacework/datacollector.log
	cleanup
	sleep 1m

	sudo systemctl start datacollector.service
	sleep 2m

	# make sure collector is running
	ps -ef | grep -q '/var/lib/lacework/datacollector -r=collector'
	if [ $? -eq 1 ]
	then
		echo "Agent failed to start, aborting test"
		exit 1
	fi

	# start the script to add interfaces and after that detroy and add more interfaces. do for 10 iterations
	sudo "$current_dir"/bridge_recycle_v4.sh "$number_intf" 3m 10 "$up_down_intf"
	sleep 1m

	sudo cp /var/log/lacework/datacollector.log "$number_intf"/
	
done

popd
