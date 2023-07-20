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

#Create web subnet az1
resource "aws_subnet" "web-az1" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.subnet_cdir["web"][0]
  availability_zone       = data.aws_availability_zones.az.names[0]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project_name}-${var.environment}-web-az1"
  }
}

#Create web subnet az2
resource "aws_subnet" "web-az2" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.subnet_cdir["web"][1]
  availability_zone       = data.aws_availability_zones.az.names[1]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project_name}-${var.environment}-web-az2"
  }
}

#Create db subnet az1
resource "aws_subnet" "data-az1" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.subnet_cdir["db"][0]
  availability_zone       = data.aws_availability_zones.az.names[0]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project_name}-${var.environment}-data-az1"
  }
}

#Create db subnet az2
resource "aws_subnet" "data-az2" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.subnet_cdir["db"][1]
  availability_zone       = data.aws_availability_zones.az.names[1]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project_name}-${var.environment}-data-az2"
  }
}