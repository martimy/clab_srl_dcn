#!/bin/bash

USER="admin"
PASSWORD="NokiaSrl1!"

FLAGS="$@"

docker run --net clab -v $(pwd)/.:/files \
--rm ghcr.io/openconfig/gnmic \
--skip-verify -u $USER -p $PASSWORD -e json_ietf $FLAGS
