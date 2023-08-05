##########################################
############## RESOURCES #################
##########################################

locals {
  databases = {
    "postgresql" = 5432
    "mysql" = 3306
    "mongodb" = 27017
  }
  db_http_port = coalesce(var.db_server_port, local.databases[var.database])
  web_http_port = coalesce(var.web_server_port, 80)
}

resource "aws_security_group" "lb-security-group" {

  name        = "${var.project_name}_lb_firewall"
  description = "Control inbound/outbound traffic in and out of the loadbalancer servers"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description = "Allow traffic from the internet"
    from_port   = local.web_http_port
    to_port     = local.web_http_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow TLS traffic from the internet"
    from_port   = 443
    to_port     = 443
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
    Name = "${local.tag_name}-lb-sg"
  }
}

resource "aws_security_group" "ecs-security-group" {

  name        = "${var.project_name}_ecs_firewall"
  description = "Control inbound/outbound traffic in and out of the ecs cluster"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description = "Allow HTTP traffic from the load balancer."
    from_port   = local.web_http_port
    to_port     = local.web_http_port
    protocol    = "tcp"
    cidr_blocks = [aws_security_group.lb-security-group.id]
  }

  ingress {
    description = "Allow TLS traffic from the load balancer."
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [aws_security_group.lb-security-group.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${local.tag_name}-ecs-sg"
  }
}

resource "aws_security_group" "web-security-group" {

  name        = "${var.project_name}_web_firewall"
  description = "Control inbound/outbound traffic in and out of the web servers"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description = "Allow HTTP traffic from ECS cluster."
    from_port   = local.web_http_port
    to_port     = local.web_http_port
    protocol    = "tcp"
    security_groups = [aws_security_group.lb-security-group.id]
  }

  ingress {
    description = "Allow TLS traffic from ECS cluster."
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    security_groups = [aws_security_group.lb-security-group.id]
  }

  ingress {
    description = "Allow traffic from private IP address."
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.ipaddr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${local.tag_name}-web-sg"
  }
}

resource "aws_security_group" "db-security-group" {

  name        = "${var.project_name}_db_firewall"
  description = "Control inbound/outbound traffic in and out of the database servers"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description     = "Allow traffic from web SG"
    from_port       = local.db_http_port
    to_port         = local.db_http_port
    protocol        = "tcp"
    security_groups = [aws_security_group.web-security-group.id]
  }

  ingress {
    description = "Allow traffic from private IP address"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.ipaddr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${local.tag_name}-db-sg"
  }
}