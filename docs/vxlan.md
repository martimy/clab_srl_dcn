# Introduction to EVPNs and VxLANs


# EVPN

Ethernet VPN (EVPN) extends the capabilities of Border Gateway Protocol (BGP) by enabling the transmission of endpoint reachability information, encompassing both Layer 2 MAC addresses and Layer 3 IP addresses. This technology utilizes Multiprotocol BGP (MP-BGP) for distributing MAC and IP address endpoint information, treating MAC addresses as routes.

Similar to other VPN technologies, EVPN instances are configured on provider edge (PE) routers to maintain logical service separation among customers. These PE routers connect to customer edge (CE) devices, which may include routers, switches, or hosts. Reachability information is exchanged between PE routers using MP-BGP, facilitating the forwarding of encapsulated traffic between them.

EVPN operates as a Layer 2 overlay solution, facilitating Layer 2 connectivity over an IP underlay for endpoints within a virtual network. It includes mechanisms to detect and mitigate issues such as MAC flapping and prevent looping of broadcast, unknown unicast, and multicast (BUM) traffic in all-active multi-homed topologies. Similar to Layer 3 MPLS VPN, EVPN incorporates the concept of routing MAC addresses using an IP/MPLS core.

## VxLAN

Virtual eXtensible Local-Area Network (VxLAN) is a standard network virtualization technology defined by the Internet Engineering Task Force (IETF). It enables the sharing of a single physical network among multiple tenants without allowing any one tenant to observe the network traffic of others.

VXLANs are encapsulated within UDP packets, allowing them to traverse any network capable of transmitting UDP packets. This means that the physical layout and geographic distance between nodes in the underlying network are irrelevant as long as UDP datagrams are forwarded between VXLAN Tunnel Endpoint (VTEP) devices for encapsulation and decapsulation.

VXLANs expand the Layer 2 network address space significantly, from 4K to 16 million, addressing scaling issues observed in VLAN-based environments. Network overlays are established by encapsulating and tunneling traffic over a physical network, with VXLAN being a common protocol for creating these overlays. Each VXLAN network identifier (VNI) uniquely identifies a Layer 2 subnet or segment, enabling communication between virtual machines within the same VNI without requiring routing, while communication across different VNIs requires a router.

## EVPN-VxLAN Integration

Integration of EVPN with VxLAN enables operators to create virtual networks from physical network ports on switches supporting the standard within the same Layer 3 network. This integration leverages VxLAN's tunneling scheme to overlay Layer 2 networks on top of Layer 3 networks, facilitating optimal forwarding of Ethernet frames and supporting multipathing of unicast and multicast traffic through UDP/IP encapsulation.

A notable feature of EVPN is its control plane MAC address learning mechanism, where MAC address learning between PE routers occurs in the control plane rather than the data plane. This method, facilitated by MP-BGP, enhances scalability and enables various useful features provided by EVPN.

Applications of these technologies include interconnecting geographically dispersed data centers, facilitating workload mobility, supporting multi-tenancy, and creating scalable overlay networks.

## RDs and RTs

VRFs allow IP address space to be reused among isolated routing domains. For example, if three customer are using the same 192.168.0.0/24 as their local network, we can assign each customer its own VRF so that the overlapping networks are kept isolated from one another in their respective routing domains.

This works well, but we need a way to keep track of which 192.168.0.0/24 route belongs to which customer. This is where route distinguishers come in. As its name implies, a route distinguisher (RD) distinguishes one set of routes (one VRF) from another. It is a unique number prepended to each route within a VRF to identify it as belonging to that particular VRF or customer. An RD is carried along with a route via MP-BGP when exchanging VPN routes with other PE routers.

Each RD makes the same IP prefix unique by appending an 8-byte RD value to the customer's IPv4 prefix. This results in a VPNv4 prefix that is unique across the service provider's network, which allows the provider's routers to store routes from different customers (even with overlapping IP addresses) in their BGP tables.

On the other hand, RTs are used to control which routes are imported and exported from a VRF. When a route is exported from a VRF, the RT value is added to the route as a BGP extended community. When the route is received on another PE router, the RT value is examined to determine which VRFs should import the route.

Whereas route distinguishers are used to maintain uniqueness among identical routes in different VRFs, route targets can be used to share routes among them. We can apply route targets to a VRF to control the import and export of routes among it and other VRFs.

A route target takes the form of an extended BGP community with a structure similar to that of a route distinguisher (which is probably why the two are so easily confused).


- [Reference 1.](https://packetlife.net/blog/2013/jun/10/route-distinguishers-and-route-targets/)
