#!/bin/bash


docker run --net host --rm \
       -v ${pwd}/sflow_update.json:/app/sflow_update.json \
       ghcr.io/openconfig/gnmic -a 172.20.20.2 \
       --skip-verify -u admin -p admin -e json_ietf \
       $@
