#!/bin/sh

if [ -z "$1" ]; then
    echo -e "Usage:\n\t`basename $0` AGENT_VERSION"
    exit 1
fi

REPO="stable"
if [ -n "$2" ]; then
    REPO="$2"
fi


DOWNLOAD_CMD=wget
type axel && DOWNLOAD_CMD=axel
$DOWNLOAD_CMD https://s3.amazonaws.com/download.draios.com/${REPO}/tgz/x86_64/draios-$1-x86_64-agent.tar.gz
