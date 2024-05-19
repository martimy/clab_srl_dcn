#!/bin/bash

set -eu

startAll() {
    echo "starting traffic on all hosts"
    docker exec host2 iperf3 -s -p 5201 -D > iperf3_1.log &
    docker exec host2 iperf3 -s -p 5202 -D > iperf3_2.log &
    docker exec host1 iperf3 -c 192.168.2.11 -t 10000 -i 1 -p 5201 -B 192.168.1.11 -P 8 -b 200K -M 1460 &
    docker exec host3 iperf3 -c 192.168.2.11 -t 10000 -i 1 -p 5202 -B 192.168.3.11 -P 8 -b 200K -M 1460 &
}

stopAll() {
    echo "stopping all traffic"
    docker exec host2 pkill iperf3
    docker exec host3 pkill iperf3
}

# start traffic
if [ $1 == "start" ]; then
    if [ $2 == "all" ]; then
        startAll
    fi
fi

if [ $1 == "stop" ]; then
    if [ $2 == "all" ]; then
        stopAll
    fi
fi
