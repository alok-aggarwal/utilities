#!/bin/bash -l

source ~/.bashrc
SHELL=/bin/bash
BASH_ENV="/home/alokaggarwal/.bashrc"
source ~/.bashrc

PATH=$PATH:/home/alokaggarwal/.local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin:/home/alokaggarwal/.local/bin

export AWS_PROFILE='draios-dev-developer'
gimme-aws-creds
