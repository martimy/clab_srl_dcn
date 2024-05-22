# YANG and XPATH


## Yang

YANG (Yet Another Next Generation) is a data modeling language used for defining network devices' configuration and state. YANG organizes the data models into hierarchy of modules and submodules. YANG is designed to be readable by both humans and machines. The YANG data can be represented in XML or JSON formats. YANG is protocol-independent, but it is primarily used with the NETCONF and gRPC protocols.

## XPATH

XPath (XML Path Language) is an expression language that uses "path-like" syntax to identify and navigate through elements and attributes in an XML document. XPath is used within YANG data models to define constraints on the elements of a YANG data model. It also allows for the selection of specific nodes in the data tree based on certain criteria.

XPath works with YANG in the following ways:

1. An XPath expression can be used to query and retrieve a specific configuration element from an XML data structure defined by a YANG model.
2. An XPath can be used to specify the conditions that a particular element in the YANG model must meet, such as matching a certain pattern or falling within a certain range.
3. XPath expressions can be used (by NETCONF, for example) to select specific parts of the configuration or state data during network operations. For instance, a NETCONF \<get\> operation might use an XPath expression to filter the data retrieved from a network device.

## Examples

Consider a simple YANG model for a network interface:

```yang
module example-interface {
    namespace "http://example.com/ns/interfaces";
    prefix "if";

    container interfaces {
        list interface {
            key "name";
            leaf name {
                type string;
            }
            leaf description {
                type string;
            }
            leaf enabled {
                type boolean;
            }
        }
    }
}
```

In an XML representation, the data might look like this:

```xml
<interfaces xmlns="http://example.com/ns/interfaces">
    <interface>
        <name>eth0</name>
        <description>Main interface</description>
        <enabled>true</enabled>
    </interface>
    <interface>
        <name>eth1</name>
        <description>Backup interface</description>
        <enabled>false</enabled>
    </interface>
</interfaces>
```

An XPath expression to select the description of the interface named "eth0" would be:

```xpath
/interfaces/interface[name='eth0']/description
```

## gNMIc and XPath

gNMIc uses YANG XPath to specify the data being requested or updated. For instance, the gNMIc `path` command, it is possible to generate and search through the XPath-style paths extracted from a YANG file. Once paths are extracted from a YANG model, it is made possible to utilize CLI search tools like `awk`, `sed` and `alike` to find the paths satisfying specific matching rules.
