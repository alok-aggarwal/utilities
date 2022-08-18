#!/bin/bash

OKTA="$1"
JUST_CONNECT="$2"

if [[ $OKTA -eq 1 ]] ; then
    echo "Verifying via okta"
    #run this script as root add the root check here
    gimme-aws-creds
fi

if [[ $JUST_CONNECT -eq 1 ]] ; then
    echo "Just Connecting..."
    IP=$(aws ec2 describe-instances --region us-east-1 --filters "Name=instance-id,Values=i-01aab55eb6e195ad7" --query "Reservations[*].Instances[*].PublicIpAddress" --output text)
    ssh "alok@$IP"
    exit 0
fi

aws ec2 start-instances --region us-east-1 --instance-ids i-01aab55eb6e195ad7

#this is where we should do status check via "aws ec2 describe-instance-status --region us-east-1 --instance-ids i-01aab55eb6e195ad7"
# but for now, sleep 60s
echo "Bringing up ec2 instance"
sleep 40s

IP=$(aws ec2 describe-instances --region us-east-1 --filters "Name=instance-id,Values=i-01aab55eb6e195ad7" --query "Reservations[*].Instances[*].PublicIpAddress" --output text)

ssh "alok@$IP"
