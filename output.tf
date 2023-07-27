# #############################################
# ################ Outputs ####################
# #############################################

output "project_name" {
  value = var.project_name
}

output "environment" {
  value = var.environment
}

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

output "tag_name" {
  value = local.tag_name
}

output "availability_zones" {
  value = local.availability_zones
}