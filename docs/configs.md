# Configuration Overview

This is still work in-progress.

![Topology](spineleaf.png)

[Another configuration example](https://networkcloudandeverything.com/configuring-srlinux-nodes-in-a-3-tier-data-center/)


## Lab Topology

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

## Configuration workflow

The following is the description of the configuration procedure. The procedure is divided into three stages:

- Configuration of eBGP with load-balancing among all switches.
- Configuration of iBGP EVPN overlay
- Configuration of VxLANs

Notes:


- The bgp-evpn configuration is not possible on network-instance of type default.
- the system0 interface can only be associated with network-instance default
