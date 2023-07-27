#########################################
############## locals ###################
#########################################

locals {
  availability_zones = slice(data.aws_availability_zones.az.names, 0, length(local.web_cidr_blocks))
  db_cidr_blocks     = var.subnet_cdir["db"]
  web_cidr_blocks    = var.subnet_cdir["web"]
  tag_name           = "${var.environment}-${var.project_name}"
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
    Name = "${local.tag_name}-vpc"
  }
}

#Create Internet Gateway
resource "aws_internet_gateway" "internet-gateway" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${local.tag_name}-igw"
  }
}

#Create web subnets
resource "aws_subnet" "web" {
  count = local.web_cidr_blocks != null ? length(local.web_cidr_blocks) : 0

  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = local.web_cidr_blocks[count.index]
  availability_zone       = local.availability_zones[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "${local.tag_name}-web-az-${count.index + 1}"
  }
}

#Create db subnets
resource "aws_subnet" "data" {
  count = local.db_cidr_blocks != null ? length(local.db_cidr_blocks) : 0

  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = local.db_cidr_blocks[count.index]
  availability_zone       = local.availability_zones[count.index]
  map_public_ip_on_launch = false

  tags = {
    Name = "${local.tag_name}-data-az-${count.index + 1}"
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
    Name = "${local.tag_name}-rt"
  }
}

#Web: route table and web subnet association
resource "aws_route_table_association" "web" {
  count = local.web_cidr_blocks != null ? length(local.web_cidr_blocks) : 0

  subnet_id      = aws_subnet.web[count.index].id
  route_table_id = aws_route_table.web-rt.id
}