#!/bin/bash
#set -e

set -x

if (( $# < 3 ))
then
	echo "Error: $0 number_of_intf sleep_time iterations"
	exit 1
fi

# Number of bridge interfaces to create
number_of_intf="$1"
# time to wait before destroying interfaces
sleep_time="$2"
# Number of iterations
iterations="$3"


# Number of interfaces to remove and add at each iteration
add_remove_number="$4"

if [[ -z "$number_of_intf" || -z $sleep_time || -z "$iterations" || -z "$add_remove_number" ]]
then
	echo "Error $0 number_of_intf sleep_time iterations"
	exit 1
fi

fpath="/tmp/$$"
mkdir -p $fpath
fpath="$fpath/runlog-$RANDOM.txt"


dumpLogData() {
	local logData=$1
	echo "=============== `/bin/date ` ===============" >> $fpath
	if [[ ! -z "$logData" ]]
	then
		echo $logData >> $fpath
	fi
}


bridge_interfaces=()

dumpLogData "$0 $number_of_intf $sleep_time $iterations $add_remove_number"


dumpLogData "Creating initial set of interfaces: $number_of_intf"

for ((i = 1 ; i <= $number_of_intf ; i++));
do
	newintf="intf$RANDOM$RANDOM"
	dumpLogData "Adding bridge interface $newintf"
	brctl addbr "$newintf"
	ip link set dev "$newintf" up
	bridge_interfaces=( "${bridge_interfaces[@]}" "$newintf" )
	sleep 1
done

dumpLogData "Finished creating interfaces"
sleep "$sleep_time"

dumpLogData "Starting iterations"

for ((c = 0; c < "$iterations"; c++));
do
	dumpLogData "Iteration: $c"
	dumpLogData "-------------Itr: $c:   Created-----------------"
	#ip addr
	dumpLogData '-------------------------------------'

	unset remove_array
	dumpLogData "list of interfaces to delete"
	remove_array=()
	size=${#bridge_interfaces[@]}
	for ((j = 0; j < "$add_remove_number"; j++));
	do
		index=0
		for (( ; ; ))
		do
			found=0
			index=$RANDOM
			let "index %= $size"
			for el in ${remove_array[@]};
			do
				itf="${bridge_interfaces[$index]}"

				echo "$itf" | grep -q "intf.* intf.* intf.*"
				if [ $? -eq 0 ]
				then
					echo "error itf $itf"
					exit 1
				fi

				echo "$el" | grep -q "intf.* intf.* intf.*"
				if [ $? -eq 0 ]
				then
					echo "error el $el"
					exit 1
				fi
		
				if [ "$itf" = "$el" ]
				then
					found=1
					break
				fi	  
			done
			
			if (( $found == 0 ))
			then
				break
			fi
		done
		
		intf=${bridge_interfaces[$index]}
		dumpLogData "Destroying interface $intf"
		ip link set dev "$intf" down
		sudo brctl delbr "$intf"
		remove_array=( "${remove_array[@]}" "$intf" )
   	done

   # Remove elements from main array
   new_array=()
   for intf in ${bridge_interfaces[@]};
   do
		found=0
		for el in ${remove_array[@]};
		do
			if [ "$el" == "$intf" ]
			then
				found=1
				break
			fi
		done
		if (( found == 0))
		then
			new_array=( "${new_array[@]}" "$intf" )
		fi
	done

	unset bridge_interfaces
	bridge_interfaces=( "${new_array[@]}" )


   for ((j = 0; j < "$add_remove_number"; j++));
	do
		newintf="intf$RANDOM$RANDOM"
		dumpLogData "Adding bridge interface $newintf"
		brctl addbr "$newintf"
		ip link set dev "$newintf" up
		bridge_interfaces=( "${bridge_interfaces[@]}" "$newintf" )
		sleep 1		
 	done
	sleep "$sleep_time"
done
echo "Done"
