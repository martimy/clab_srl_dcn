

# https://github.com/openconfig/gnmic
# https://github.com/karimra/gnmic-nanog87

Install gNMIc on the host or use Docker

docker run --rm --net host ghcr.io/openconfig/gnmic -u admin -p admin -e json_ietf -a 172.20.20.2 --skip-verify capabilities

gnmic --config .gnmic.yaml get --path /system/snmp

gnmic --config .gnmic.yaml subscribe --path /interface/subinterface/statistics/out-octets --mode stream --stream-mode sample --sample-interval 10s

gnmic --config .gnmic.yaml subscribe --path /interface/subinterface/statistics/out-octets --mode stream --stream-mode on-change

gnmic --config .gnmic.yaml subscribe --path /interface/subinterface/oper-state --mode stream --stream-mode on-change

gnmic generate --file  srlinux-yang-models/srl_nokia/models/interfaces/srl_nokia-tools-interfaces.yang --dir srlinux-yang-models

gnmic generate path --file  srlinux-yang-models/srl_nokia/models/interfaces/srl_nokia-tools-interfaces.yang --dir srlinux-yang-models



gnmic --config .gnmic.yaml -a 172.20.20.2 get --path /system/name/host-name

gnmic --config .gnmic.yaml -a 172.20.20.2 get --path /interface[name=ethernet-1/1]

gnmic --config .gnmic.yaml -a 172.20.20.2 get --path /interface[name=ethernet-1/1] -t config

gnmic --config .gnmic.yaml -a 172.20.20.2 set --update-path /interface[name=ethernet-1/2]/admin-state --update-value enable

gnmic --config .gnmic.yaml -a 172.20.20.2 set \
--update-path /acl/acl-sets \
--update-file acl2.json

gnmic --config gnmic.yaml set --update-path /system/sflow --update-file sflow_update.yaml

gnmic --config gnmic.yaml set --update-path /system/sflow --update-file sflow_update.yaml
