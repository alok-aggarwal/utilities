#!/bin/bash

#set -xe

export CGO_LDFLAGS_ALLOW=".*--wrap=memcpy.*"

cd linux;  go test -benchmem -run=^$ . -bench Benchmark; cd ..
cd datacollector

cd nsmgr;  go test -benchmem -run=^$ . -bench Benchmark; cd ..
cd nshelper;  go test -benchmem -run=^$ . -bench Benchmark; cd ..

cd config; go test -benchmem -run=^$ . -bench Benchmark; cd ..
cd controller; go test -benchmem -run=^$ . -bench Benchmark; cd ..
cd dctest; go test -benchmem -run=^$ . -bench Benchmark; cd ..
cd lwclient; go test -benchmem -run=^$ . -bench Benchmark; cd ..
cd misc; go test -benchmem -run=^$ . -bench Benchmark; cd ..
cd netflow; go test -benchmem -run=^$ . -bench Benchmark; cd ..
cd netstat; go test -benchmem -run=^$ . -bench Benchmark; cd ..
cd sink; go test -benchmem -run=^$ . -bench Benchmark; cd ..
cd state; go test -benchmem -run=^$ . -bench Benchmark; cd ..
cd unixipc; go test -benchmem -run=^$ . -bench Benchmark; cd ..
cd containers; go test -benchmem -run=^$ . -bench Benchmark; cd ..

cd dctest/controller; go test -benchmem -run=^$ . -bench Benchmark; cd ../../
cd lwclient/messages; go test -benchmem -run=^$ . -bench Benchmark; cd ../../
cd lwclient/codegen; go test -benchmem -run=^$ . -bench Benchmark; cd ../../
cd netflow/perf; go test -benchmem -run=^$ . -bench Benchmark; cd ../../
cd netflow/ctrack; go test -benchmem -run=^$ . -bench Benchmark; cd ../../
cd netstat/process; go test -benchmem -run=^$ . -bench Benchmark; cd ../../
cd netstat/machine; go test -benchmem -run=^$ . -bench Benchmark; cd ../../
cd netstat/inodemap; go test -benchmem -run=^$ . -bench Benchmark; cd ../../
cd netstat/auditmap; go test -benchmem -run=^$ . -bench Benchmark; cd ../../
cd netstat/sockmap; go test -benchmem -run=^$ . -bench Benchmark; cd ../../
cd netstat/containermap; go test -benchmem -run=^$ . -bench Benchmark; cd ../../
cd sink/filestrm; go test -benchmem -run=^$ . -bench Benchmark; cd ../../
cd sink/localdb; go test -benchmem -run=^$ . -bench Benchmark; cd ../../
cd fim/diskcrawl; go test -benchmem -run=^$ . -bench Benchmark; cd ../../
