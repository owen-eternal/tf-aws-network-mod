#########################################
############## locals ###################
#########################################

locals {
  availability_zones = slice(data.aws_availability_zones.az.names, 0, length(local.web_cidr_blocks))

  tag_name        = "${var.project_name}-${var.environment}"

  web_cidr_blocks = var.subnet_cdir["web"]

  db_cidr_blocks  = var.subnet_cdir["db"]
  
  security_group_description = {
    "web" = {
      "description" = "Control inbound/outbound traffic in and out of the web servers"
      "port"        = coalesce(var.web_server_port, 80)
    },
    "db" = {
      "description" = "Control inbound/outbound traffic in and out of the database servers"
      "port"        = coalesce(var.db_server_port, 80)
    }
  }
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

resource "aws_security_group" "security-groups" {
  for_each = local.security_group_description

  name        = "${var.project_name}_${each.key}_firewall"
  description = each.value["description"]
  vpc_id      = aws_vpc.vpc.id

  ingress {
    from_port   = each.value["port"]
    to_port     = each.value["port"]
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${local.tag_name}-${each.key}-sg"
  }
}