# Data Centre Lab using Nokia Service Router Linux

[![Static Badge](https://img.shields.io/badge/Docs-github.io-blue)](https://martimy.github.io/clab_srl_dcn)

This is lab builds a spine-leaf data centre network using Nokia [Service Router Linux](https://www.nokia.com/networks/ip-networks/service-router-linux-NOS/) (srlinux) and Conatinerlab. The lab documentation can be found [here](docs/index.md).

The main features of Nokia srlinux can be found [here](https://learn.srlinux.dev/) and they include:

- [Open Architucture](https://documentation.nokia.com/srlinux/SR_Linux_HTML_R21-11/Configuration_Basics_Guide/configb-apps.html)
- [Groud-up support of YANG](https://learn.srlinux.dev/programmability/)

Nokia SRLinux can be managed with CLI, gNMI, JSON-RPC, and SNMP.

This lab uses [Release 21.11](https://documentation.nokia.com/srlinux/21-11/index.html), which is not the latest but the container size is smaller.

For more information about creating Containerlab topologies using srlinux, consult [this resource](https://containerlab.dev/manual/kinds/srl/#__tabbed_1_5).


There are two topologies included in this lab. The main topology include six routers and five servers, including a network management server. The second topology is smaller and it includes three switches and four servers.

The lab includes start-up router configuration files for both topologies that feature VxLAN implementation over the underlay DC fabric.


![Lab Topology #1](docs/main_topo.png)

![Lab Topology #2](docs/tiny_topo.png)


# Starting and stopping the lab

To start the lab's main topology:

```
$ sudo clab deploy -t srl-dc.clab.yaml
```

To stop the lab

```
$ sudo clab destroy -t srl-dc.clab.yaml --cleanup
```

To start the lab's smaller topology:

```
$ sudo clab deploy -t tiny.clab.yaml
```

To stop the lab

```
$ sudo clab destroy -t tiny.clab.yaml --cleanup
```

# Nokia Switch Access

1. CLI Access

    ```
    $ docker exec -it clab-srl-s1 sr_cli
    ```

2. SSH Access

    ```
    $ ssh clab-srl-s1
    ```

To exit, type 'quit'.


3. SNMP Connectivity

    To test SNMP connection (using default community string):

    ```
    $ docker exec -it clab-srl-mgm snmpwalk -v 2c -c public 172.20.20.11
    ```

4. JSON-RPC Connectivity

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
## Host access

Depending on the type of host container used, you may be able to:

- execute commands diractly via Docker:

    ```
    $ docker exec -it clab-srl-h1 ping 192.168.3.101
    ```

- or, access the shell:

    ```
    $ docker exec -it clab-srl-h1 bash
    ```

- or log in via ssh (use admin/admin)

    ```
    $ ssh admin@clab-tiny-h2
    ```
# Traffic capture

To capture traffic from one of the hosts:

```
docker exec clab-tiny-h1 tshark -i eth1
```

To capture traffic on links between routers, attach a container to one of the links:

```
docker run -it --rm --privileged --net container:clab-tiny-r2 akpinar/alpine:lat
est tshark -i e1-12
```

or

```
docker run -it --rm --net container:clab-tiny-r2 nicolaka/netshoot tshark -i e1-12
```

# Misc show commands

```
show interface brief
```

```
show network-instance summary
```

Show routing table

```
show network-instance default route-table ipv4-unicast summary
```

to verify BGP neighbours:

```
show network-instance default protocols bgp neighbor
```

Verify connectivity from a router (running mode)

```
ping network-instance default 10.10.10.102
```

Verify connectivity from a host to another

```
$ docker exec -it clab-srl-h1 ping 192.168.3.101
```
