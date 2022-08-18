#!/bin/bash

#run this script as root add the root check here
gimme-aws-creds

aws ec2 start-instances --region us-east-1 --instance-ids i-01aab55eb6e195ad7

#this is where we should do status check via "aws ec2 describe-instance-status --region us-east-1 --instance-ids i-01aab55eb6e195ad7"
# but for now, sleep 60s
echo "Bringing up ec2 instance"
sleep 60s

IP=$(aws ec2 describe-instances --region us-east-1 --filters "Name=instance-id,Values=i-01aab55eb6e195ad7" --query "Reservations[*].Instances[*].PublicIpAddress" --output text)

ssh "alok@$IP"
#commands to build agent
cd ~/workspace/agent
git checkout drift
git pull
#install build container:
docker start -ia 58ecaa6a6d1d
#come out of ssh
exit


IP=$(aws ec2 describe-instances --region us-east-1 --filters "Name=instance-id,Values=i-01aab55eb6e195ad7" --query "Reservations[*].Instances[*].PublicIpAddress" --output text)

sudo scp alok@$IP:workspace/artifactory/draios/bin/dragent /home/alokaggarwal/workspace/artifactory/draios/bin

aws ec2 stop-instances --region us-east-1 --instance-ids i-01aab55eb6e195ad7


#to build and get container
# run build container with container target
# get agent image id
# tag it
# push it inside ssh machine
# after coming out of ssh pull it on your machine
#alok@ip-172-31-53-226:~$ docker images
#REPOSITORY                      TAG               IMAGE ID       CREATED          SIZE
#agent                           latest            f083a3672e15   32 seconds ago   1.6GB
#alok-agent-11-2                 latest            6d9e1d046e01   6 days ago       1.59GB

#alok@ip-172-31-53-226:~$ docker tag f08 quay.io/sysdig/dev:alok-agent-11-4

#alok@ip-172-31-53-226:~$ docker push quay.io/sysdig/dev:alok-agent-11-4


### steps for starting ssh-agent and to prevent being asked the ssh key password every time
### start ssh agent if it is not runnign already
#alok@ip-172-31-53-226:~$ eval $(ssh-agent)
#Agent pid 10651
#alok@ip-172-31-53-226:~$ ssh-add
###how do you answer passwd prompt via a script?
#Enter passphrase for /home/alok/.ssh/id_rsa:
###Identity added: /home/alok/.ssh/id_rsa (alok.aggarwal@sysdig.com)

