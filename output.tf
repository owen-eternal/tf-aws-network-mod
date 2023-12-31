# #############################################
# ################ Outputs ####################
# #############################################

output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "internet_gateway_id" {
  value = aws_internet_gateway.internet-gateway.id
}

output "web_subnet_ids" {
  value = aws_subnet.web[*].id
}

output "db_subnet_ids" {
  value = aws_subnet.data[*].id
}

output "web_route_table_id" {
  value = aws_route_table.web-rt.id
}

output "web_security_group_id" {
  value = aws_security_group.web-security-group.id
}

output "db_security_group_id" {
  value = aws_security_group.db-security-group.id
}

output "lb_security_group_id" {
  value = aws_security_group.lb-security-group.id
}

output "tag_name" {
  value = local.tag_name
}

output "availability_zones" {
  value = local.availability_zones
}

output "application_port" {
  value = local.web_http_port
}