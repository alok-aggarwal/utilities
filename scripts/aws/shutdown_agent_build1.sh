#!/bin/bash -l


source ~/.bashrc
SHELL=/bin/bash
BASH_ENV="/home/alokaggarwal/.bashrc"
source ~/.bashrc

PATH=$PATH:/home/alokaggarwal/.local/bin
export AWS_PROFILE='draios-dev-developer'
aws ec2 stop-instances --region us-east-1 --instance-ids i-01aab55eb6e195ad7

