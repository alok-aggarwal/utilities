#!/bin/bash

rm -rf drcpu
mkdir drcpu
for i in drcpu.prof.*; do
    google-pprof --callgrind /home/alokaggarwal/bugs/esc-1649/05_11/12_4_0_bin/opt/draios/bin/dragent $i --lib_prefix=/home/alokaggarwal/bugs/esc-1649/05_11/12_4_0_image > drcpu/`basename $i`.callgrind & echo;
    sleep 5s
done

exit 0
