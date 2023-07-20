## TF-NETWORK: MODULE

### This terraform module creates a standard AWS VPC network with the following resources:
- subnets:
-- x1 `Internet Gateway` to route traffic in and out of the VPC.
-- x2 `web application` subnet (Public), each in it's respective AZ
-- x2 `database subnet` (Private), each in it's respective AZ
-- x1 `Public Route Table` to route traffic to web application subnet.