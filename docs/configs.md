# Configuration Overview

This is still work in-progress.

![Topology](spineleaf.png)

[Another configuration example](https://networkcloudandeverything.com/configuring-srlinux-nodes-in-a-3-tier-data-center/)



## Bridge configuration workflow:

- configure network interfaces
- configure IRB interface
- configure mac-vrf instance
- configure ip-vrf instance
- associate IRB interface with ip-vrf

```
show network-instance MYNET route-table all
```

- The bgp-evpn configuration is not possible on network-instance of type default.
- the system0 interface can only be associated with network-instance default

### EVPN

EVPN is an extension to BGP that allows the network to carry endpoint reachability information such as Layer 2 MAC addresses and Layer 3 IP addresses. EVPN also provides multipath forwarding and redundancy through an all-active multihoming model. An endpoint or device can connect to two or more upstream devices and forward traffic using all the links. If a link or device fails, traffic continues to flow using the remaining active links.


### Lab Configuration

The default lab configuration creates a Data Centre fabric using BGP, EVPN, and VxLAN technologies. Here is a description of the overall topology:

- The DC consists of two spine switches, three leaf switches, and one border switch.
- There are five servers connected to the leaf switches as follows:
   - Server1 is connected to Leaf1
   - Server2 and Server3 are connected to Leaf2
   - Server4 is connected to Leaf3
   - Server5 is connected to Border1
- Server1-3 reside on the same subnet
- Server4 and Server5 are on separate subnet

The goal of the configuration is to allow connectivity among all servers over the DC fabric.

### Configuration workflow

The following is the description of the configuration procedure. The procedure is divided into three stages:

- Configuration of eBGP with load-balancing among all switches.
- Configuration of iBGP EVPN overlay
- Configuration of VxLANs
