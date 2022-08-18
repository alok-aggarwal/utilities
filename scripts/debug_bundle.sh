if [[ ${UID} -ne 0 ]]
then
 echo "Please run as root"
 exit 1
fi
set -x


#create a tmp file on the host
echo "Lacework debug file on the host" > /tmp/lacework_debug

#Lacework container
LACEWORK=$(docker ps | grep -e 'lacework' | grep -v grep | grep -v pause | awk '{print $1}')

#Set of commands to be executed inside the lacework container
cat > inside_container.sh << CONTEOF
#!/bin/bash

curl -sSL https://s3-us-west-2.amazonaws.com/www.lacework.net/download/3.4.17_2021-01-07_medallia_debug_79de74d1412a73b64634f904819d095cab88740d/datacollector.gz > datacollector.gz

gunzip datacollector.gz

mv datacollector lacework_debug_binary

chmod 777 lacework_debug_binary

./lacework_debug_binary -ns mnt -distro 2 > lacework_debug_out

#delete the debug binary
rm -rf lacework_debug_binary

exit
CONTEOF

chmod 777 inside_container.sh

#copy the commands file inside lacework container
docker cp inside_container.sh $LACEWORK:/inside_container.sh

#execute commands
docker exec -it $LACEWORK ./inside_container.sh

#copy the test output back to host
docker cp $LACEWORK:lacework_debug_out .

#delete the tmp file
rm -rf /tmp/lacework_debug

echo "All done, please email the file lacework_debug_out"
