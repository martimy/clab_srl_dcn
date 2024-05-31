# Introduction to Nokia SR Linux

Nokia Service Router Linux (SR Linux) is an open and extensible network operating system (NOS). Here are the features of SR Linux:

- It uses an unmodified Linux kernel as its foundation.
- It is intentionally designed to be extensible and customizable by users.
- It is designed for automation; each network application has its own YANG data structure.
- It a state-sharing architecture using protobufs, gRPC, and the lightweight Nokia Impart Database (IDB).

Find more information [here](https://www.nokia.com/networks/ip-networks/service-router-linux-NOS/).

The following is some of the important information that you need for this lab:

## CLI

The Command Line Interface (CLI) for SR Linux can be accessed either through a console connection or an SSH (Secure Shell) connection. These are different modes that the CLI can operate in, each mode provides different functionalities and capabilities for managing the system. Here's a brief description of each mode:

- Running Mode: This mode reflects the current active configuration of the system.
- Candidate Mode: This mode allows for editing and reviewing the system configuration before committing it to the running mode. It provides a safe environment to make and validate changes before applying them.
- Show Mode: This mode is used to display the current state and configuration of the system. It is essentially a read-only mode for monitoring purposes.
- State Mode: This mode provides detailed information about the operational state of various system components. It goes beyond the configuration to include real-time data such as interface statistics, protocol states, and other dynamic operational details.
- OC (Operational Configuration) Mode: This mode combines the operational and configuration views, focusing on the dynamic aspects of the system that can be altered during runtime. It enables users to see how changes in configuration affect the operational state and make adjustments accordingly.


The CLI has auto-complete function that you can use to reduce keystrokes or aid in remembering a command name. Use the tab key at any mode or level to auto-complete the next command level. When a command is partially entered, the remainder of the command appears ahead of the prompt in lighter text.

Wildcards and Ranges are used in CLI commands to represent multiple values or a series of values. For example, the wildcard `*` can be used to represent any number of characters, and a range like `1-5` can represent any number between 1 and 5.

These are some specific commands that you can use in the CLI to perform common tasks, such as `info` and `show` to display detailed information about a specific configuration or system state, `ping` and `traceroute` to test the network connectivity between two nodes in the network.

For more information consult [this resource](https://learn.srlinux.dev/cli/).

## Network Interfaces

An interface in SR Linux is any physical or logical port through which packets can be sent to or received from other devices. The SR Linux supports the following interface types:

- Loopback: Virtual interface always up, named loN.
- System: Special loopback with restrictions, named system0.
- Management: For out-of-band management, named mgmt0.
- Network: Carry transit traffic, named ethernet-slot/port.
- IRB: Integrated routing and bridging, named irbN.

Sub-interfaces are logical channels within a parent interface. Every interface must have one sub-interface. Loopback, System and Management interfaces can have only one sub-interface. Network interfaces can have more than one sub-interface if VLAN tagging is enabled.

Integrated routing and bridging (IRB) interfaces enable inter-subnet forwarding. Network instances of type mac-vrf are associated with a network instance of type ip-vrf via an IRB interface.

## Network Instances

On the SR Linux device, you can configure one or more network instances (aka VRF). Each network-instance has its own interfaces, its own protocol instances, its own route table, and its own FIB.

These are the types of supported network instances:

- Default: The default network-instance. Only one is allowed.
- IP-VRF: Regular network-instance for IP routing.
- MAC-VRF: Broadcast domain associated with an IP-VRF via IRB.

IRB Interfaces link MAC-VRF and IP-VRF instances for Layer 2 traffic tunneling across an IP network.
