#!/bin/bash -l

exec "$@"
SHELL=/bin/bash
BASH_ENV="/home/alokaggarwal/.bashrc"
PATH=$PATH:/home/alokaggarwal/.local/bin
export AWS_PROFILE='draios-dev-developer'
