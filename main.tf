#########################################
############## locals ###################
#########################################

locals {
  web_cidr_blocks = var.subnet_cdir["web"]
  db_cidr_blocks = var.subnet_cdir["db"]
}

#########################################
############## DATA SOURCES #############
#########################################

data "aws_availability_zones" "az" {}

##########################################
############## RESOURCES #################
##########################################

#Create VPC
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cdir
  enable_dns_hostnames = true

  tags = {
    Name = "${var.project_name}-${var.environment}-vpc"
  }
}

# Create Internet Gateway
resource "aws_internet_gateway" "internet-gateway" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.project_name}-${var.environment}-igw"
  }
}

#Create web subnets
resource "aws_subnet" "web" {
  count                   = local.web_cidr_blocks != null ? length(local.web_cidr_blocks) : 0

  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = local.web_cidr_blocks[count.index]
  availability_zone       = data.aws_availability_zones.az.names[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project_name}-${var.environment}-web-az-${count.index + 1}"
  }
}

#Create db subnets
resource "aws_subnet" "data" {
  count                   = local.db_cidr_blocks != null ? length(local.db_cidr_blocks) : 0
  
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = local.db_cidr_blocks[count.index]
  availability_zone       = data.aws_availability_zones.az.names[count.index]
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.project_name}-${var.environment}-data-az-${count.index + 1}"
  }
}

#Public Route Table
resource "aws_route_table" "web-rt" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet-gateway.id
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-rt"
  }
}

#Web Subnet Associations
resource "aws_route_table_association" "web" {
  count          = local.web_cidr_blocks != null ? length(local.web_cidr_blocks) : 0
  subnet_id      = aws_subnet.web[count.index].id
  route_table_id = aws_route_table.web-rt.id
}

resource "aws_security_group" "web-sg" {
  name        = "${var.project_name}-websg"
  description = "Control inbound/outbound traffic to web servers"
  vpc_id      = aws_vpc.vpc.id

  tags = {
    Name = "${var.project_name}-${var.environment}-sg"
  }
}