# Data Centre Lab using Nokia Service Router Linux

This is lab builds a network tpology using Nokia [Service Router Linux](https://www.nokia.com/networks/ip-networks/service-router-linux-NOS/) (srlinux) and Conatinerlab.

The main features of Nokia srlinux can be found [here](https://learn.srlinux.dev/) and they include:

- [Open Architucture](https://documentation.nokia.com/srlinux/SR_Linux_HTML_R21-11/Configuration_Basics_Guide/configb-apps.html)
- [Groud-up support of YANG](https://learn.srlinux.dev/programmability/)

Nokia SRLinux can be managed with CLI, gNMI, JSON-RPC, and SNMP.

Here is the link to [router documentation](https://documentation.nokia.com/srlinux/index.html). This lab uses [Release 21.11](https://documentation.nokia.com/srlinux/21-11/index.html).

For more information about creating Containerlab topologies using srlinux, consult [this](https://containerlab.dev/manual/kinds/srl/#__tabbed_1_5).


![Lab Topology](docs/spineleaf.png)

The lab documentation is [here](docs/index.md)

## Accessing the lab

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
$ docker exec -it clab-srl-s1 sr_cli
```

or

```
$ ssh clab-srl-s1
```

To exit, type 'quit'.


# SNMP Access

To test SNMP connection (using default community string):

```
$ docker exec -it clab-srl-mgm snmpwalk -v 2c -c public 172.20.20.11
```

# JSON-RPC

```
curl http://admin:admin@clab-srl-s1/jsonrpc -d @- << EOF
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

# configuration Notes

```
show interface brief
```

The hardware type 'ixrd1' has 52 interfaces and one management interface.
Interfaces e1-1 to e1-48 are 1G, interfaces e1-49 to e1-52 are 10G, interface mgmt is 1G.

Here is a list of hardward

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
$ docker exec -it clab-srl-h1 ping 192.168.3.101
```
