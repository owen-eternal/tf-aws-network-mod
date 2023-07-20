#############################################
################ Outputs ####################
#############################################

output "vpc" {
  value = aws_vpc.vpc.id
}

output "avaiability_zone_1" {
  value = data.aws_availability_zones.az.names[0]
}

output "avaiability_zone_2" {
  value = data.aws_availability_zones.az.names[1]
}

output "web_subnet_az1" {
  value = aws_subnet.web-az1.cidr_block
}

output "web_subnet_az2" {
  value = aws_subnet.web-az2.cidr_block
}

output "data_subnet_az1" {
  value = aws_subnet.data-az1.cidr_block
}

output "data_subnet_az2" {
  value = aws_subnet.data-az2.cidr_block
}

output "internet_gateway" {
  value = aws_internet_gateway.internet-gateway.id
}

output "web_route_table" {
  value = aws_route_table.web-rt.id
}