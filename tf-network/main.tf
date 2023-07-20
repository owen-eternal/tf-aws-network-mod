#Create VPC
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cdir
  enable_dns_hostnames = true

  tags = {
    Name = "${var.project_name}-${var.environment}-vpc"
  }
}