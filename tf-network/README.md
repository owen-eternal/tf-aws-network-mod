# TF-NETWORK-MODULE:

#### This terraform module creates a standard AWS VPC network with the following resources:

1. subnets:
    1. x2 `web application` subnet (Public), each in it's respective AZ
    1. x2 `database subnet` (Private), each in it's respective AZ
1. Route Tables:
    1. x1 `Public Route Table`to route traffic from the internet to the web application subnet.
1. Internet Gateway: to route traffic in and out of the VPC.