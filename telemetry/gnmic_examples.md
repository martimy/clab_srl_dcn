# gNMIc Usage Examples

The following is a set of examples on how to use gNMIc to execute four common operations:

- Capabilities Request
- Get Request
- Set Request
- Subscribe Request

For more information about the gNMIc commands, consult the [command reference](https://gnmic.openconfig.net/cmd/capabilities).

To use these example, you need to either:

- Install gNMIc on your host machine using these [instructions](https://gnmic.openconfig.net/install/), or
- Use the gNMIc docker image.

To simplify the latter approach, use the script `gnmic_cmd.sh` to execute the command using the following format:

```
$ ./gnmic_cmd <target> <command> [local flags]
```

Begin by deploying the topology:

```
$ sudo clab deploy
```

To retrieve the Capabilities:

```
$ ./gnmic_cmd.sh leaf1 capabilities
gNMI version: 0.10.0
supported models:
  - urn:srl_nokia/aaa:srl_nokia-aaa, Nokia, 2023-10-31
  - urn:srl_nokia/aaa-password:srl_nokia-aaa-password, Nokia, 2023-10-31
<ommitted output>
  - urn:srl_nokia/tools-twamp:srl_nokia-tools-twamp, Nokia, 2023-10-31
  - urn:srl_nokia/tools-vxlan-tunnel:srl_nokia-tools-vxlan-tunnel, Nokia, 2021-03-31
supported encodings:
  - JSON_IETF
  - PROTO
  - ASCII
<ommitted output>
```

If gNMIc is installed in the host machine, you may proceed with the following commands (I'll use this method for the remainder of this document).

```
$ export GNMIC_USERNAME=admin
$ export GNMIC_PASSWORD=NokiaSrl1!
$ gnmic -a leaf1 --skip-verify -e json_ietf get --path /system/name/host-name
[
  {
    "source": "leaf1",
    "timestamp": 1716212340126416300,
    "time": "2024-05-20T10:39:00.1264163-03:00",
    "updates": [
      {
        "Path": "srl_nokia-system:system/srl_nokia-system-name:name/host-name",
        "values": {
          "srl_nokia-system:system/srl_nokia-system-name:name/host-name": "leaf1"
        }
      }
    ]
  }
]
```

To retrieve interface information:

```
$ gnmic -a leaf1 --skip-verify -e json_ietf get --path /interface[name=ethernet-1/11]
[
  {
    "source": "leaf1",
    "timestamp": 1716212619549184990,
    "time": "2024-05-20T10:43:39.54918499-03:00",
    "updates": [
      {
        "Path": "srl_nokia-interfaces:interface[name=ethernet-1/11]",
        "values": {
          "srl_nokia-interfaces:interface": {
            "admin-state": "enable",
            "description": "Leaf1 to Spine1",
            "ethernet": {
              "dac-link-training": false,
              "flow-control": {
                "receive": false
              },
              "hw-mac-address": "1A:38:05:FF:00:0B",
<output omitted>
]
```

To get configuration only:

```
$ gnmic -a leaf1 --skip-verify -e json_ietf get --path /interface[name=ethernet-1/11] -t config
[
  {
    "source": "leaf1",
    "timestamp": 1716212838155540424,
    "time": "2024-05-20T10:47:18.155540424-03:00",
    "updates": [
      {
        "Path": "srl_nokia-interfaces:interface[name=ethernet-1/11]",
        "values": {
          "srl_nokia-interfaces:interface": {
            "admin-state": "enable",
            "description": "Leaf1 to Spine1",
            "subinterface": [
              {
                "admin-state": "enable",
                "index": 0,
                "ipv4": {
                  "address": [
                    {
                      "ip-prefix": "10.10.10.2/30"
                    }
                  ],
                  "admin-state": "enable"
                }
              }
            ]
          }
        }
      }
    ]
  }
]
```

To retrieve information from multiple target, list the target separated by comma in the command line:

```
$ gnmic -a spine1,spine2 --skip-verify -e json_ietf get --path /interface[name=ethernet-1
/11] -t config
[spine2] [
[spine2]   {
[spine2]     "source": "spine2",
[spine2]     "timestamp": 1716213038576787259,
[spine2]     "time": "2024-05-20T10:50:38.576787259-03:00",
[spine2]     "updates": [
[spine2]       {
[spine2]         "Path": "srl_nokia-interfaces:interface[name=ethernet-1/11]",
[spine2]         "values": {
[spine2]           "srl_nokia-interfaces:interface": {
[spine2]             "admin-state": "enable",
[spine2]             "description": "Spine2 to Leaf1",
[spine2]             "subinterface": [
[spine2]               {
[spine2]                 "admin-state": "enable",
[spine2]                 "index": 0,
[spine2]                 "ipv4": {
[spine2]                   "address": [
[spine2]                     {
[spine2]                       "ip-prefix": "10.10.10.13/30"
[spine2]                     }
[spine2]                   ],
[spine2]                   "admin-state": "enable"
[spine2]                 }
[spine2]               }
[spine2]             ]
[spine2]           }
[spine2]         }
[spine2]       }
[spine2]     ]
[spine2]   }
[spine2] ]
[spine1] [
[spine1]   {
[spine1]     "source": "spine1",
[spine1]     "timestamp": 1716213038637291232,
[spine1]     "time": "2024-05-20T10:50:38.637291232-03:00",
[spine1]     "updates": [
[spine1]       {
[spine1]         "Path": "srl_nokia-interfaces:interface[name=ethernet-1/11]",
[spine1]         "values": {
[spine1]           "srl_nokia-interfaces:interface": {
[spine1]             "admin-state": "enable",
[spine1]             "description": "Spine1 to Leaf1",
[spine1]             "subinterface": [
[spine1]               {
[spine1]                 "admin-state": "enable",
[spine1]                 "index": 0,
[spine1]                 "ipv4": {
[spine1]                   "address": [
[spine1]                     {
[spine1]                       "ip-prefix": "10.10.10.1/30"
[spine1]                     }
[spine1]                   ],
[spine1]                   "admin-state": "enable"
[spine1]                 }
[spine1]               }
[spine1]             ]
[spine1]           }
[spine1]         }
[spine1]       }
[spine1]     ]
[spine1]   }
[spine1] ]
```

An example of set command:

```
$ gnmic -a spine1 --skip-verify -e json_ietf set \
--update-path interface[name=ethernet-1/11]/admin-state \
--update-value enable \
--update-path interface[name=ethernet-1/11]/subinterface[index=0]/admin-state \
--update-value enable
{
  "source": "spine1",
  "timestamp": 1716213602767574118,
  "time": "2024-05-20T11:00:02.767574118-03:00",
  "results": [
    {
      "operation": "UPDATE",
      "path": "interface[name=ethernet-1/11]/admin-state"
    },
    {
      "operation": "UPDATE",
      "path": "interface[name=ethernet-1/11]/subinterface[index=0]/admin-state"
    }
  ]
}
```

Use the above command to verify that the configuration is successful.

```
$ gnmic -a spine1 --skip-verify -e json_ietf get --path /interface[name=ethernet-1/11] -t config
```

To configure one or more inter using a file:

```
$ gnmic -a spine1 --skip-verify -e json_ietf set \
--update-path interface[name=ethernet-1/11] \
--update-file interface_config.json \
--update-path interface[name=ethernet-1/12] \
--update-file interface_config.json
{
  "source": "spine1",
  "timestamp": 1716215793483416038,
  "time": "2024-05-20T11:36:33.483416038-03:00",
  "results": [
    {
      "operation": "UPDATE",
      "path": "interface[name=ethernet-1/11]"
    },
    {
      "operation": "UPDATE",
      "path": "interface[name=ethernet-1/12]"
    }
  ]
}
```

You can use subscribe command to collect statistics from an interface (notice the mode):

```
$ gnmic -a spine1 --skip-verify -e json_ietf subscribe \
--path /interface[name=ethernet-1/11]/statistics \
--mode stream \
--stream-mode sample \
--sample-interval 10s

{
  "source": "spine1",
  "subscription-name": "default-1716216021",
  "timestamp": 1716216021772041987,
  "time": "2024-05-20T11:40:21.772041987-03:00",
  "updates": [
    {
      "Path": "srl_nokia-interfaces:interface[name=ethernet-1/11]/statistics",
      "values": {
        "srl_nokia-interfaces:interface/statistics": {
          "carrier-transitions": "1",
          "in-broadcast-packets": "7",
          "in-discarded-packets": "0",
          "in-error-packets": "5",
          "in-fcs-error-packets": "0",
          "in-multicast-packets": "129",
          "in-octets": "43355",
          "in-packets": "402",
          "in-unicast-packets": "261",
          "out-broadcast-packets": "5",
          "out-discarded-packets": "0",
          "out-error-packets": "0",
          "out-mirror-octets": "0",
          "out-mirror-packets": "0",
          "out-multicast-packets": "130",
          "out-octets": "43310",
          "out-packets": "395",
          "out-unicast-packets": "260"
        }
      }
    }
  ]
}
```


## Configuration Example

The routers' startup configuration provided in the lab does not enable ECMP (Equal-cost multi-path routing) on BGP routes. This example shows how to use gNMIc to enable ECMP on the routers using YANG models.

First, to verify the status of ECMP on a router, login to the router and use a show command to display the routing table:

```
$ ssh admin@leaf1  

```

```
A:leaf1# show network-instance default route-table summary
------------------------------------------------------------------------------
IPv4 Route Summary
------------------------------------------------------------------------------
Name      Protocol   Active Routes
default   bgp        10
default   host       7
default   local      3
------------------------------------------------------------------------------
IPv4 Active routes          : 20
IPv4 Active routes with ECMP: 0
IPV4 Resilient hash routes  : 0
IPv4 Failed routes          : 0
IPv4 Total routes           : 20
------------------------------------------------------------------------------
<output ommitted>
```

Exit the router (type quit followed by ENTER or hit CTRL-D).


We need to use YANG models to get information form the routers as well as update the configuration. The YANG modeled data follows a tree-like hierarchy where each node can be uniquely identified with a schema path. Knowing the path to any YANG modeled data is necessary to manipulate it. To learn about the YANG models' paths used by the Nokia SR Linux router, we can extract this information from the router itself or refer to Nokia's [Path Browser](https://yang.srlinux.dev/v23.10.3) for the specific OS version used.

We can extract the YANG models from the srlinux image using a shell script[^cr], which takes the OS version as input. The script saves the models into directory `srlinux-yang-models`:

[^cr]: Copyright 2020 Nokia

```
$ ./extract.sh 23.10.1
```

Next, we search for a path that provides state information about the ECMP active routers. For that, we use the gNMIc `path` command. The flag `--state-only` retrieves paths that represent state information and ignore configuration paths.

```
$ gnmic path --file srlinux-yang-models --state-only | grep ecmp
/network-instance[name=*]/route-table/ipv4-unicast/statistics/active-routes-with-ecmp
/network-instance[name=*]/route-table/ipv6-unicast/statistics/active-routes-with-ecmp
/network-instances/network-instance[name=*]/protocols/protocol[identifier=*][name=*]/isis/global/afi-safi/af[afi-name=*][safi-name=*]/state/max-ecmp-paths
/network-instances/network-instance[name=*]/protocols/protocol[identifier=*][name=*]/isis/global/state/max-ecmp-paths
/network-instances/network-instance[name=*]/protocols/protocol[identifier=*][name=*]/isis/global/state/weighted-ecmp
/network-instances/network-instance[name=*]/protocols/protocol[identifier=*][name=*]/isis/interfaces/interface[interface-id=*]/weighted-ecmp/state/load-balancing-weight
```

We see that the first path retrieved provides the state information for the active ECMP routes, so we will use this path in the `get` command. Note that the network-instance (VRF) is not specified so we get the number of active ECMP routes for the two active instances `mgmt` and `default`:

```
$ gnmic -a leaf1 --skip-verify -e json_ietf get --path /network-instance/route-table/ipv4-unicast/statistics/active-routes-with-ecmp
[
  {
    "source": "leaf1",
    "timestamp": 1716313393931406788,
    "time": "2024-05-21T14:43:13.931406788-03:00",
    "updates": [
      {
        "Path": "",
        "values": {
          "": {
            "srl_nokia-network-instance:network-instance": [
              {
                "name": "default",
                "route-table": {
                  "srl_nokia-ip-route-tables:ipv4-unicast": {
                    "statistics": {
                      "active-routes-with-ecmp": 0
                    }
                  }
                }
              },
              {
                "name": "mgmt",
                "route-table": {
                  "srl_nokia-ip-route-tables:ipv4-unicast": {
                    "statistics": {
                      "active-routes-with-ecmp": 0
                    }
                  }
                }
              }
            ]
          }
        }
      }
    ]
  }
]
```

Now, we will use the same approach to find the configuration path required to enable ECMP on the routers (with help from documentation, we can find that we need to use `multipath`):

```
$ gnmic path --file srlinux-yang-models --config-only | grep multipath
/network-instance[name=*]/protocols/bgp/afi-safi[afi-safi-name=*]/add-paths/send-multipath
/network-instance[name=*]/protocols/bgp/afi-safi[afi-safi-name=*]/multipath/allow-multiple-as
/network-instance[name=*]/protocols/bgp/afi-safi[afi-safi-name=*]/multipath/max-paths-level-1
/network-instance[name=*]/protocols/bgp/afi-safi[afi-safi-name=*]/multipath/max-paths-level-2
/network-instance[name=*]/protocols/bgp/group[group-name=*]/afi-safi[afi-safi-name=*]/add-paths/send-multipath
/network-instance[name=*]/protocols/bgp/neighbor[peer-address=*]/afi-safi[afi-safi-name=*]/add-paths/send-multipath
/network-instance[name=*]/protocols/ldp/multipath/max-paths
```

Note that there three path that relate to the multipath configuration whose parent path is: `/network-instance[name=*]/protocols/bgp/afi-safi[afi-safi-name=*]/multipath/`

The `generate` command takes the target's YANG models as input and generates the paths required and the configuration payloads needed to update or replace the path using the `set` command. The `--file` flag points to the YANG model directory.

```
$ gnmic -a leaf1 generate \
--file srlinux-yang-models \
--path /network-instance[name=default]/protocols/bgp/afi-safi[afi-safi-name=*]/multipath/
allow-multiple-as:
- "true"
max-paths-level-1:
- "1"
max-paths-level-2:
- "1"
```

From the output of the generate command, we see that we need to increase the number of max-paths to a number higher that 1. We can use `set` command with flags `--update-path` and `--update-value`:

```
$ gnmic -a leaf1 --skip-verify -e json_ietf set \
--update-path /network-instance[name=default]/protocols/bgp/afi-safi/multipath/max-paths-level-1 \
--update-value 32 \
--update-path /network-instance[name=default]/protocols/bgp/afi-safi/multipath/max-paths-level-2 \
--update-value 32
```

We can do the same for all remaining routers:

```
$ gnmic -a leaf1,leaf2,leaf3,spine1,spine2 --skip-verify -e json_ietf set \
--update-path /network-instance[name=default]/protocols/bgp/afi-safi/multipath/max-paths-level-1 \
--update-value 32 \
--update-path /network-instance[name=default]/protocols/bgp/afi-safi/multipath/max-paths-level-2 \
--update-value 32
[spine1] {
[spine1]   "source": "spine1",
[spine1]   "timestamp": 1716298550676122192,
[spine1]   "time": "2024-05-21T10:35:50.676122192-03:00",
[spine1]   "results": [
[spine1]     {
[spine1]       "operation": "UPDATE",
[spine1]       "path": "network-instance[name=default]/protocols/bgp/afi-safi/multipath/max-paths-level-1"
[spine1]     },
[spine1]     {
[spine1]       "operation": "UPDATE",
[spine1]       "path": "network-instance[name=default]/protocols/bgp/afi-safi/multipath/max-paths-level-2"
[spine1]     }
[spine1]   ]
[spine1] }
<output-ommitted>
```

To verify that the update is successful, use the previous commands:

```
gnmic -a leaf1 --skip-verify -e json_ietf get --path /network-instance/route-table/ipv4-unicast/statistics/active-routes-with-ecmp
[
  {
    "source": "leaf1",
    "timestamp": 1716315256166817595,
    "time": "2024-05-21T15:14:16.166817595-03:00",
    "updates": [
      {
        "Path": "",
        "values": {
          "": {
            "srl_nokia-network-instance:network-instance": [
              {
                "name": "default",
                "route-table": {
                  "srl_nokia-ip-route-tables:ipv4-unicast": {
                    "statistics": {
                      "active-routes-with-ecmp": 4
                    }
                  }
                }
              },
              {
                "name": "mgmt",
                "route-table": {
                  "srl_nokia-ip-route-tables:ipv4-unicast": {
                    "statistics": {
                      "active-routes-with-ecmp": 0
                    }
                  }
                }
              }
            ]
          }
        }
      }
    ]
  }
]
```

Also, login to one of the leaf routers and issue one of the show commands below and observe the number of ECMP routes.

```
$ ssh admin@leaf1
```

```
A:leaf1# show network-instance default route-table ipv4-unicast summary

<output omitted>
------------------------------------------------------------------------------
IPv4 routes total                    : 20
IPv4 prefixes with active routes     : 20
IPv4 prefixes with active ECMP routes: 4
------------------------------------------------------------------------------
```

```
A:leaf1# show network-instance default protocols bgp routes ipv4 summary

<output omitted>
------------------------------------------------------------------------------
24 received BGP routes: 18 used, 24 valid, 0 stale
18 available destinations: 6 with ECMP multipaths
------------------------------------------------------------------------------
```
