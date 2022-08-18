#cleanup
sleep 30

sudo systemctl start datacollector.service

sleep 5

COLLECTOR=$(ps -ef | awk '$11=="-r=collector" {print $2}')
NSHELPER=$(ps -ef | awk '$10=="mnt" {print $2}')

echo $COLLECTOR
echo $NSHELPER

ps -ef | grep datacollector

# make sure collector/nshelper is running
ps -ef | grep -q 'collector'
if [ $? -eq 1 ]
then
        echo "Agent failed to start, aborting test"
        exit 1
fi

ps -ef | grep -q 'mnt'
if [ $? -eq 1 ]
then
        echo "nshelper failed to start, aborting test"
        exit 1
fi

psrecord $COLLECTOR --interval 3 --log agent_usage.txt --duration 60 --include-children

psrecord $NSHELPER --interval 3 --log nshelper_usage.txt --duration 60

psrecord $COLLECTOR --interval 3 --log collector_usage.txt --duration 60
sleep 1m



sudo systemctl stop datacollector.service
#COLLECTOR=$(ps -ef | awk '$8=="/var/lib/lacework2/datacollector_setns" {print $2}')
#CONTROLLER=$(ps -ef | awk '$8=="./datacollector_setns" {print $2}')
#kill -9 $COLLECTOR
#kill -9 $CONTROLLER

#docker stop nginx
#docker stop redis

#cp "$agent1_log_dir"/datacollector.log /home/centos/pkgScanContResults/datacollector.log.cont
#cp "$agent2_log_dir"/datacollector.log /home/centos/pkgScanContResults/datacollector.log.binary

