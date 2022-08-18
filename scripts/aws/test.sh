#!/bin/bash

OKTA="$1"

if [[ $OKTA -eq "1" ]] ; then
    echo "Verifying via okta"
    #run this script as root add the root check here
fi
