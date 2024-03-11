#!/bin/bash


docker run --net host --rm ghcr.io/openconfig/gnmic -a 172.20.20.2 \
       --skip-verify -u admin -p admin -e json_ietf \
       $@
