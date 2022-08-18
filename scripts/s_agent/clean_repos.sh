#!/bin/bash

cd workspace/
rm -rf *
mkdir -p artifactory
git clone -b dev ssh://git@github.com/draios/agent.git
git clone -b master-sync ssh://git@github.com/draios/oss-falco.git
git clone -b master ssh://git@github.com/draios/protorepo.git
git clone -b dev ssh://git@github.com/draios/agent-libs.git
git clone -b dev ssh://git@github.com/draios/probe-builder.git
~                                                                
