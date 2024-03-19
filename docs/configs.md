# Configuration Overview

This is still work in-progress.

This configuration is based on the following:

- [Nokia Tutorial](https://learn.srlinux.dev/tutorials/)
- [Another Tutorial](https://networkcloudandeverything.com/configuring-srlinux-nodes-in-a-3-tier-data-center/)

![Topology](spineleaf.png)



## Lab Topology

The default lab configuration creates a Data Centre fabric using BGP, EVPN, and VxLAN technologies. Here is a description of the overall topology:

- The DC consists of two spine switches, three leaf switches, and one border switch.
- There are five servers connected to the leaf switches as follows:
   - Server1 is connected to Leaf1
   - Server2 and Server3 are connected to Leaf2
   - Server4 is connected to Leaf3
   - Server5 is connected to Border1
- Server1-3 reside on the same subnet and the need to communicate at layer 2
- Server4 and Server5 are on separate subnets

The goal of the configuration is to allow connectivity among all servers over the DC fabric.

## Configuration workflow

The following is the description of the configuration procedure. The procedure is divided into three stages:

- Fabric Configuration
- EVPN Configuration
- VxLAN Configuration

Notes:

- The bgp-evpn configuration is not possible on network-instance of type default.
- the system0 interface can only be associated with network-instance default

### Fabric Configuration

Prior to configuring EVPN based overlay, a routing protocol needs to be deployed in the fabric to advertise the reachability of all the leaf VXLAN Termination End Point (VTEP) addresses throughout the IP fabric.

Therefore, we need to configure BGP between five autonomous systems (AS). One AS includes the spine switches. Each of the other ASs includes one leaf or border switch. The purpose of configure eBGP is to create an underlay infrastructure that share all *system0* (loopback) IP addresses that will be used later.

The configuration includes the following steps (order is not import as long as all steps are completed before committing the configuration):

- Define the *system0.0* interface and assign an IPv4 address:

    Switch | *system0.0* IPv4 Address
    ---|----
    S1 | 1.1.1.1
    S2 | 1.1.1.2
    L1 | 1.1.1.11
    L2 | 1.1.1.12
    L3 | 1.1.1.13
    B1 | 1.1.1.21

- Define the network interfaces for inter-switch links and assigning a /30 IP address to each:

    Link | IPv4 Subnet
    ---|---
    S1 -- L1 | 10.10.10.0/24
    S1 -- L2 | 10.10.10.4/24
    S1 -- L4 | 10.10.10.8/24
    S1 -- B1 | 10.10.10.100/24
    S2 -- L1 | 10.10.10.12/24
    S2 -- L2 | 10.10.10.16/24
    S2 -- L4 | 10.10.10.20/24
    S2 -- B1 | 10.10.10.104/24

- Define the *default* network instance and add all interfaces to it.
- Configure a routing policy to allow the exchange of the above addresses.
- Configure BGP:
   - Define the local AS number:

     Switch | ASN
     ---|----
     S1 | 65000
     S2 | 65000
     L1 | 65001
     L2 | 65002
     L3 | 65003
     B1 | 65101

   - Define a peer group and assign the local ASN and routing policy to it.
   - Define all neighbours
   - on leaf switches only, enable ECMP load balancing.

At the end of this stage, you should be able to see all BGP neighbours and the advertised routes.

### EVPN Configuration

The previous configuration enable us to establish iBGP EVPN sessions between the Leaf and Spine routers. In this stage we create iBGP configuration by including all routers in one AS (65500). The configuration for all routers will be the same but spine will be used also as route reflectors.

Follow these steps in leaf and border switches:

- define a BGP group of type evpn and
  - assign it a local AS 65600.
  - assign it a transport local-address (use system0.0)
- define the two spine switches as neighbours in the peer group

In the spine switches:

- define a BGP peer-group of type evpn and
  - assign it a local AS 65600.
  - assign it a transport local-address (use system0.0)
  - define rule-reflector
- define all leaf and border switches neighbours in the peer group
