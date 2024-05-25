# ECMP Configuration

The routers' startup configuration provided in the lab does not enable ECMP (Equal-cost multi-path routing) on BGP routes. This document shows how to use gNMIc to enable ECMP on the routers using YANG models.

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

## Using `generate` command

The `generate` command takes the target's YANG models as input and generates the paths required and the configuration payloads needed to update or replace the path using the `set` command. The `--file` flag points to the YANG model directory.

```
$ gnmic generate \
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
<output ommitted>
```

To verify that the update is successful, use the previous commands:

```
$ gnmic -a leaf1 --skip-verify -e json_ietf get --path /network-instance/route-table/ipv4-unicast/statistics/active-routes-with-ecmp
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

# Using `--update-file` Flag


The previous approach works well with small updates. For more complex configuration, we may need to update/replace the configuration using configuration files instead. To perfom the same function as above, you we need to use the commands below:

First, direct the output of the `generate` command to a file:

```
$ gnmic generate --file srlinux-yang-models --path /network-instance[name=default]/protocols/bgp/afi-safi[afi-safi-name=*]/multipath > ecmp_config.yaml
```

Edit the `ecmp_config.yaml` file to match the following:

```
allow-multiple-as: true
max-paths-level-1: 32
max-paths-level-2: 32
```

Use the `set` command with the flag `--update-file`:

```
$ gnmic -a leaf1,leaf2,leaf3,spine1,spine2 --skip-verify -e json_ietf set \
--update-path /network-instance[name=default]/protocols/bgp/afi-safi[afi-safi-name=*]/multipath \
--update-file ecmp_config.yaml
```

The output should look like the following:

```
[leaf3] {
[leaf3]   "source": "leaf3",
[leaf3]   "timestamp": 1716643248109869583,
[leaf3]   "time": "2024-05-25T10:20:48.109869583-03:00",
[leaf3]   "results": [
[leaf3]     {
[leaf3]       "operation": "UPDATE",
[leaf3]       "path": "network-instance[name=default]/protocols/bgp/afi-safi[afi-safi-name=*]/multipath"
[leaf3]     }
[leaf3]   ]
[leaf3] }
[leaf2] {
<output ommitted>
```

# Using `generate set-request` Command

The 'generate' command works well with small updates. For more complex configuration, we may need to update/replace the configuration using configuration files instead. The `generate set-request` commad generates the required configuration file in YAML (default) or JSON format. To perfom the same function as above, you we need to use the command below:

The set-request sub command generates a request file given a list of update and/or replace paths. The generated file can be manually edited and used with `set` command. The file can be useful to perfom a set of complex configuration update/replace operations. The generated file can also be used to create configuration templates.

Generate the request file:

```
$ gnmic generate set-request \
--file srlinux-yang-models \
--update /network-instance[name=default]/protocols/bgp/afi-safi/multipath > ecmp_request.yaml
```

The generated YAML file is:

```yaml
updates:
- path: /network-instance[name=default]/protocols/bgp/afi-safi/multipath
  value:
    allow-multiple-as:
    - "true"
    max-paths-level-1:
    - "1"
    max-paths-level-2:
    - "1"
```

Now, we can edit the file to change the max paths to, say, 16 then use the `set` command with `--request-file flag`:

```yaml
updates:
- path: /network-instance[name=default]/protocols/bgp/afi-safi/multipath
  value:
    allow-multiple-as: true
    max-paths-level-1: 16
    max-paths-level-2: 16
```

```
$ gnmic -a leaf1,leaf2,leaf3,spine1,spine2 --skip-verify -e json_ietf set \
--request-file ecmp_request.yaml
```

The output will be:

```
[leaf2] {
[leaf2]   "source": "leaf2",
[leaf2]   "timestamp": 1716644297609868128,
[leaf2]   "time": "2024-05-25T10:38:17.609868128-03:00",
[leaf2]   "results": [
[leaf2]     {
[leaf2]       "operation": "UPDATE",
[leaf2]       "path": "network-instance[name=default]/protocols/bgp/afi-safi/multipath"
[leaf2]     }
[leaf2]   ]
[leaf2] }
<output ommitted>
```

## Update vs Replace

All previous examaples use "update" flags. The same commands can also be used with "replace" flags. There are several difference between the two, which are explained in the documentation. The main difference is:

- The updates will change existing data elements or create new ones if the element does not exist.
- The replace will change existing data elements but will not create new ones. A data element will be deleted if it is missing from the replace command.
