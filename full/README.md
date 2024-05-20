# VxLAN in a Data Centre

[![Static Badge](https://img.shields.io/badge/Docs-github.io-blue)](https://martimy.github.io/clab_srl_dcn)

This lab demonstrates the configuration of VxLAN in a data centre using BGP underlay.

This lab uses [Release 21.11](https://documentation.nokia.com/srlinux/21-11/index.html), which is not the latest but the container size is smaller.


![Lab Topology #1](../docs/main_topo.png)


# Starting and stopping the lab

To deploy the topology:

```
$ sudo clab deploy [-t srl-dc.clab.yaml]
```

To stop the lab

```
$ sudo clab destroy [-t srl-dc.clab.yaml] [--cleanup]
```
