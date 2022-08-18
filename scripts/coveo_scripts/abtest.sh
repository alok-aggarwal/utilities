#!/bin/bash
docker run -dit --log-opt max-size=10m --name docker0 -p 8080:80 httpd:2.4 &

for i in {1..200}
do

        #-c concurrency. Number of multiple requests to perform at a time. Default is one request at a time.
        #-n requests Number of requests to perform for the benchmarking session. The default is to just perform a single request which usually leads to non-representative benchmarking results.
        ab -k -c 1000 -n 10000 http://172.31.1.18:8080/
        sleep 3s

done

