Here is a summary of available interfaces and network instances:

## Interfaces:

An interface in SR Linux is any physical or logical port through which packets can be sent to or received from other devices. The SR Linux supports the following interface types:

- **Loopback**: Virtual interface always up, named loN.
- **System**: Special loopback with restrictions, named system0.
- **Management**: For out-of-band management, named mgmt0.
- **Network**: Carry transit traffic, named ethernet-slot/port.
- **IRB**: Integrated routing and bridging, named irbN.

Subinterfaces are Logical channels within a parent interface. Every interface must have one subinterface. Loopback, System and Management interfaces can have only one subinterface. Network interfaces can have more than one subinterface if vlan tagging is enabled.

Integrated routing and bridging (IRB) interfaces enable inter-subnet forwarding. Network instances of type mac-vrf are associated with a network instance of type ip-vrf via an IRB interface.

## Network Instances:

On the SR Linux device, you can configure one or more network instances (aka VRF). Each network-instance has its own interfaces, its own protocol instances, its own route table, and its own FIB.

These are the types of supported network instances:

- **Default**: The default network-instance.
- **IP-VRF**: Regular network-instance for IP routing.
- **MAC-VRF**: Broadcast domain associated with an IP-VRF via IRB.

IRB Interfaces link MAC-VRF and IP-VRF instances for Layer 2 traffic tunneling across an IP network.


# Bridge configuration workflow:

- configure network interfaces
- configure IRB interface
- configure mac-vrf instance
- configure ip-vrf instance
- associate IRB interface with ip-vrf

```
show network-instance MYNET route-table all
```

The bgp-evpn configuration is not possible on network-instance of type default.
the system0 interface can only be associated with network-instance default

# EVPN

EVPN is an extension to BGP that allows the network to carry endpoint reachability information such as Layer 2 MAC addresses and Layer 3 IP addresses. EVPN also provides multipath forwarding and redundancy through an all-active multihoming model. An endpoint or device can connect to two or more upstream devices and forward traffic using all the links. If a link or device fails, traffic continues to flow using the remaining active links.
