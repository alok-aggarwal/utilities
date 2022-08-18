#!/bin/bash
sar -u 5 10 >> cpu_stats.txt &
sleep 10
