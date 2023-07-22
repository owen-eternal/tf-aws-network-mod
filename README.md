# TF-NETWORK-MODULE:

## Infrastructure

The purpose of this module is to provision a specific infrastructure with the following components:

Subnets: It creates two "web application" subnets that are public and distributed across their respective Availability Zones (AZs). Additionally, it sets up two "database subnets" that are private and distributed across their respective AZs. This arrangement ensures separation and security for different types of resources within the Virtual Private Cloud (VPC).

Route Tables: The module establishes a single "Public Route Table" that facilitates the routing of traffic from the internet to the web application subnets. This allows users to access the web application from the public internet.

Internet Gateway: An Internet Gateway is provisioned to enable inbound and outbound internet traffic flow for the VPC. This gateway acts as a bridge between the VPC and the public internet.

Security Groups: The module configures Security Groups that are used to control traffic both inbound and outbound for the servers. Security Groups act as virtual firewalls, ensuring that only authorized traffic can access the servers and resources in the VPC while providing an additional layer of protection.

By orchestrating these components, the module creates a well-structured and secure infrastructure that supports web applications while effectively managing network traffic and access controls.

# Instructions

**This module provides a set of input and output variables that enable users to customize and access the parameters within the module. The input variables include:**

## Input Variables

 `vpc_cdir:` Required input of type `string` that represents the CIDR Block Range for the VPC network. Users must specify the valid CIDR range they want to use for their VPC.

`project_name:` Required input of type `string` that allows users to define the project name that will be utilizing this module. It helps in identifying and organizing resources associated with the specific project.

`environment:` Required input of type `string` that defines the workspace under which the network is provisioned. This variable is useful for managing multiple environments like production, staging, and development.

`subnet_cdir:` Required input of type `map(list)` that expects a mapping of subnets, where each key is a subnet name and each value is a list of CIDR Block Ranges for that subnet. This allows users to specify multiple subnets and their respective CIDR ranges within the module.

Additionally, the module provides optional input variables:

`web_server_port:` This optional input of type `string` that allows users to specify a custom port for the Web Security Group. If left unset (or set as null), it defaults to port `80`, providing a convenient default value.

`db_server_port:` This optional input of type `string` that permits users to define a custom port for the Database Security Group. If not specified (or set as null), it defaults to port `80`.

By utilizing these input variables, users have the flexibility to tailor the module's behavior to their specific requirements and create VPC networks with custom configurations and security group port settings.

usage:

```hcl
    module "tf-network-module" {
        source          = git@github.com:owen-eternal/tf-netwok-module.git
        vpc_cdir        = "10.0.0.0/16"

        project_name    = "your-project-name"

        environment     = terraform.workspace

        web_server_port = null

        db_server_port  = 443

        subnet_cdir     = {
            web = ["10.0.0.0/18", "10.0.64.0/18"]
            db  = ["10.0.128.0/18", "10.0.192.0/18"]
        }
    }
```

## Output Variables

`vpc_id:` Parameter of type `string`, serves as a reference to the VPC ID. It allows users to easily access and identify the specific VPC associated with their infrastructure.

`internet_gateway_id:` Parameter of type `string`, serves as a reference to the Internet Gateway. By providing this parameter, users can efficiently link their VPC to the internet, enabling inbound and outbound communication with external networks.

`web_subnet_ids:` Parameter of type `list`, used to reference the Public web subnet IDs. It allows users to access and manage multiple web subnets easily, which are typically used for hosting web applications in different Availability Zones (AZs).

`db_subnet_ids:` Parameter of type `list`, used to reference the Public database subnet IDs. It enables users to handle multiple database subnets conveniently, ensuring secure and isolated storage for their database resources.

`web_route_table_id:` Parameter of type `string`, used to reference the Public web route table IDs. By providing this value, users can effectively direct network traffic from the internet to the web subnets, facilitating accessibility to their web applications.

`web_security_group_id:` Parameter of type `string` and allows users to reference the security group dedicated to web servers. It provides an additional layer of security by controlling inbound and outbound traffic for web applications.

`db_security_group_id:` Parameter of type `string`, serves as a reference to the security group designated for database servers. By utilizing this value, users can manage access controls and secure communication for their database resources.

usage:
```hcl
    resource "aws_instance" "application_server-b" {
        ami                    = ...
        instance_type          = ...
        key_name               = ...
        subnet_id              = module.tf-network-module.web_subnet_ids[0]    vpc_security_group_ids = [module.tf-network-module.web_security_group_id]
    }
```
