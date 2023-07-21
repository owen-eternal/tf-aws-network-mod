# TF-NETWORK-MODULE:

## Infrastructure
This module Provisions the following infrastructure:

- subnets:
    - x2 `web application` subnet (Public), each in it's respective AZ
    - x2 `database subnet` (Private), each in it's respective AZ
- Route Tables:
    - x1 `Public Route Table`to route traffic from the internet to the web application subnet.
- Internet Gateway: to route traffic in and out of the VPC.
- Security Groups: To control traffic in and out of the servers.

## Parameters
A set of input and output variables that allow users of this module to access variables Parameters within the module 