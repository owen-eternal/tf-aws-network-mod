##########################################
############## RESOURCES #################
##########################################

resource "aws_security_group" "lb-security-group" {

  name        = "${var.project_name}_lb_firewall"
  description = "Control inbound/outbound traffic in and out of the loadbalancer servers"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description = "Allow traffic from the internet"
    from_port   = var.web_server_port
    to_port     = var.web_server_port
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

resource "aws_security_group" "web-security-group" {

  name        = "${var.project_name}_web_firewall"
  description = "Control inbound/outbound traffic in and out of the web servers"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description = "Allow traffic from Loadbalancer SG"
    from_port   = var.web_server_port
    to_port     = var.web_server_port
    protocol    = "tcp"
    security_groups = [aws_security_group.lb-security-group.id]
  }

  ingress {
    description = "Allow TLS traffic from Loadbalancer SG"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    security_groups = [aws_security_group.lb-security-group.id]
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
    Name = "${local.tag_name}-web-sg"
  }
}

resource "aws_security_group" "db-security-group" {

  name        = "${var.project_name}_db_firewall"
  description = "Control inbound/outbound traffic in and out of the database servers"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description     = "Allow traffic from web SG"
    from_port       = var.db_server_port
    to_port         = var.db_server_port
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