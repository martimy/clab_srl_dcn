# Data Centre Lab using Nokia Service Router Linux

This is lab builds a network tpology using Nokia [Service Router Linux](https://www.nokia.com/networks/ip-networks/service-router-linux-NOS/) (srlinux) and Conatinerlab.

Among the main features of Nokia srlinux are:

- [Open Architucture](https://documentation.nokia.com/srlinux/SR_Linux_HTML_R21-11/Configuration_Basics_Guide/configb-apps.html)
- [Groud-up support of YANG](https://learn.srlinux.dev/programmability/)

and many [others](https://learn.srlinux.dev/).

For more information about creating Containerlab topologies using srlinux, consult [this](https://containerlab.dev/manual/kinds/srl/#__tabbed_1_5).

To start the lab

```
$ sudo clab deploy
```

To stop the lab

```
$ sudo clab destroy --cleanup
```



To access Nokia router:

```
$ docker exec -it clab-ynet-srl sr_cli
```

or

```
$ ssh clab-ynet-srl
```

To exit, type 'quit'.


# SNMP Access

To test SNMP connection (using default community string):

```
$ docker exec -it clab-ynet-mgm snmpwalk -v 2c -c public 172.20.20.11
```

# JSON-RPC

```
curl http://admin:admin@clab-ynet-s1/jsonrpc -d @- << EOF
{
    "jsonrpc": "2.0",
    "id": 0,
    "method": "get",
    "params":
    {
        "commands":
        [
            {
                "path": "/system/information/version",
                "datastore": "state"
            }
        ]
    }
}
EOF
```


[Another configuration example](https://networkcloudandeverything.com/configuring-srlinux-nodes-in-a-3-tier-data-center/)


# configuration Notes

```
show interface brief
```

The hardware type 'ixrd3' has 34 interfaces and one management interface.
Interfaces e1-1 and e1-2 are 10G, interface mgmt is 1G; all others are 100G.

```
show network-instance summary
```

Show routing table

```
show network-instance default route-table ipv4-unicast summary
```

Verify connectivity from a router

```
ping network-instance default 10.10.10.102 
```


to verify BGP neighbours:

```
show network-instance default protocols bgp neighbor 
```

Verify connectivity from a host to another

```
$ docker exec -it clab-ynet-h1 ping 192.168.3.101
```

or using host names:

```
$ docker exec -it clab-ynet-h1 ping h3 
```

