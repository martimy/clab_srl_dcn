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


To test SNMP connection:

```
$ docker exec -it clab-ynet-mgm snmpwalk -v 2c -c linuxro 172.20.20.2
```
