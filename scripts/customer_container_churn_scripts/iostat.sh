#!/bin/bash
EPOCH=`/bin/date +%s`

while true
do
        iostat -xk >> /tmp/iostat-${EPOCH}
        ls -latr /var/lib/lacework/collector/3.2.183/Db >> /tmp/fstat-${EPOCH}
        sleep 0.05s
done

