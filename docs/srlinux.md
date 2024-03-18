# Introduction to Nokia SR Linux

Nokia Service Router Linux (SR Linux) is an open and extensible network operating system (NOS). Here are the features of SR Linux:

- It uses an unmodified Linux kernel as its foundation.
- It is intentionally designed to be extensible and customizable by users.
- It is designed for automation; each network application has its own YANG data structure.
- It a state-sharing architecture using protobufs, gRPC, and the lightweight Nokia Impart Database (IDB).

Find more information [here](https://prod.nokia.com/networks/ip-networks/service-router-linux-NOS/).

The following is some of the important information that you need for this lab:

## Interfaces:

An interface in SR Linux is any physical or logical port through which packets can be sent to or received from other devices. The SR Linux supports the following interface types:

- Loopback: Virtual interface always up, named loN.
- System: Special loopback with restrictions, named system0.
- Management: For out-of-band management, named mgmt0.
- Network: Carry transit traffic, named ethernet-slot/port.
- IRB: Integrated routing and bridging, named irbN.

Sub-interfaces are logical channels within a parent interface. Every interface must have one sub-interface. Loopback, System and Management interfaces can have only one sub-interface. Network interfaces can have more than one sub-interface if VLAN tagging is enabled.

Integrated routing and bridging (IRB) interfaces enable inter-subnet forwarding. Network instances of type mac-vrf are associated with a network instance of type ip-vrf via an IRB interface.

## Network Instances:

On the SR Linux device, you can configure one or more network instances (aka VRF). Each network-instance has its own interfaces, its own protocol instances, its own route table, and its own FIB.

These are the types of supported network instances:

- Default: The default network-instance. Only one is allowed.
- IP-VRF: Regular network-instance for IP routing.
- MAC-VRF: Broadcast domain associated with an IP-VRF via IRB.

IRB Interfaces link MAC-VRF and IP-VRF instances for Layer 2 traffic tunneling across an IP network.
