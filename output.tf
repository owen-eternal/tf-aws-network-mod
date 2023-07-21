# #############################################
# ################ Outputs ####################
# #############################################

output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "internet_gateway_id" {
  value = aws_internet_gateway.internet-gateway.id
}

output "web_subnets_id" {
  value = aws_subnet.web[*].id
}

output "db_subnets_ids" {
  value = aws_subnet.data[*].id
}

output "web_route_table_id" {
  value = aws_route_table.web-rt.id
}

output "web_security_group_id" {
  value = aws_security_group.security-groups["web"].id
}

output "db_security_group_id" {
  value = aws_security_group.security-groups["db"].id
}