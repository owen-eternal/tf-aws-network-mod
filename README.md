# TF-NETWORK-MODULE:

## Infrastructure

The purpose of this module is to provision a specific infrastructure with the following components:

Subnets: It creates two "web application" subnets that are public and distributed across their respective Availability Zones (AZs). Additionally, it sets up two "database subnets" that are private and distributed across their respective AZs. This arrangement ensures separation and security for different types of resources within the Virtual Private Cloud (VPC).

Route Tables: The module establishes a single "Public Route Table" that facilitates the routing of traffic from the internet to the web application subnets. This allows users to access the web application from the public internet.

Internet Gateway: An Internet Gateway is provisioned to enable inbound and outbound internet traffic flow for the VPC. This gateway acts as a bridge between the VPC and the public internet.

Security Groups: The module configures Security Groups that are used to control traffic both inbound and outbound for the servers. Security Groups act as virtual firewalls, ensuring that only authorized traffic can access the servers and resources in the VPC while providing an additional layer of protection.

By orchestrating these components, the module creates a well-structured and secure infrastructure that supports web applications while effectively managing network traffic and access controls.

## Instructions

# Input Variables

This module provides a set of input and output variables that enable users to customize and access the parameters within the module. The input variables include:

1. `vpc_cdir:` Required input of type `string` that represents the CIDR Block Range for the VPC network. Users must specify the valid CIDR range they want to use for their VPC.

1. `project_name:` Required input of type `string` that allows users to define the project name that will be utilizing this module. It helps in identifying and organizing resources associated with the specific project.

1. `environment:` Required input of type `string` that defines the workspace under which the network is provisioned. This variable is useful for managing multiple environments like production, staging, and development.

1. `subnet_cdir:` Required input of type `map(list)` that expects a mapping of subnets, where each key is a subnet name and each value is a list of CIDR Block Ranges for that subnet. This allows users to specify multiple subnets and their respective CIDR ranges within the module.

Additionally, the module provides optional input variables:

1. `web_server_port:` This optional input of type `string` that allows users to specify a custom port for the Web Security Group. If left unset (or set as null), it defaults to port `80`, providing a convenient default value.

1. `db_server_port:` This optional input of type string that permits users to define a custom port for the Database Security Group. If not specified (or set as null), it defaults to port `80`.

By utilizing these input variables, users have the flexibility to tailor the module's behavior to their specific requirements and create VPC networks with custom configurations and security group port settings.