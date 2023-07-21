# #############################################
# ################ Outputs ####################
# #############################################

output "vpc" {
  value = aws_vpc.vpc.id
}

output "internet_gateway" {
  value = aws_internet_gateway.internet-gateway.id
}

output "web_subnets" {
  value = aws_subnet.web[*].id
}

output "db_subnets" {
  value = aws_subnet.data[*].id
}

output "web_route_table" {
  value = aws_route_table.web-rt.id
}

output "web_security_group_id" {
  value = aws_security_group.security-groups["web"].id
}

output "db_security_group_id" {
  value = aws_security_group.security-groups["db"].id
}