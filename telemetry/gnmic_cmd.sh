#!/bin/bash

USER="admin"
PASSWORD="NokiaSrl1!"

NODE=$1
shift
OTHERS="$@"

docker run --net clab --rm ghcr.io/openconfig/gnmic -a $NODE \
       --skip-verify -u $USER -p $PASSWORD -e json_ietf $OTHERS
