# gNMIc Usage Examples

The following is a set of examples on how to use gNMIc to execute four common operations:

- Capabilities Request
- Get Request
- Set Request
- Subscribe Request

To use these example, you need to either:

- Install gNMIc on your host machine using these [instructions](https://gnmic.openconfig.net/install/), or
- Use the gNMIc docker image.

To simplify the latter approach, use the script `gnmic_cmd.sh` to execute the command using the following format:

```bash
$ ./gnmic_cmd <target> <commands and flags>
```

Begin by deploying the topology:

```bash
$ sudo clab deploy
```

To retrieve the Capabilities:

```bash
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

```bash
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

```bash
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

```bash
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

```bash
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

```bash
$ gnmic -a spine1 --skip-verify -e json_ietf set \
> --update-path interface[name=ethernet-1/11]/admin-state \
> --update-value enable \
> --update-path interface[name=ethernet-1/11]/subinterface[index=0]/admin-state \
> --update-value enable
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

```bash
$ gnmic -a spine1 --skip-verify -e json_ietf set \
> --update-path interface[name=ethernet-1/11] \
> --update-file interface_config.json \
> --update-path interface[name=ethernet-1/12] \
> --update-file interface_config.json
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

```bash
$ gnmic -a spine1 --skip-verify -e json_ietf subscribe \
> --path /interface[name=ethernet-1/11]/statistics \
> --mode stream \
> --stream-mode sample \
> --sample-interval 10s

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

You can also use a configuration file to specify the subscriptions.
