#!/bin/bash

USER="admin"
PASSWORD="admin"

NODE=$1
shift
OTHERS="$@"

docker run --net host --rm ghcr.io/openconfig/gnmic -a $NODE \
       --skip-verify -u $USER -p $PASSWORD -e json_ietf $OTHERS
