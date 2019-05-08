resource "aws_vpc" "staging" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_internet_gateway" "staging" {
  vpc_id = "${aws_vpc.staging.id}"
}

resource "aws_route" "staging_internet_access" {
  route_table_id         = "${aws_vpc.staging.main_route_table_id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.staging.id}"
}

resource "aws_subnet" "staging" {
  vpc_id                  = "${aws_vpc.staging.id}"
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
}

resource "aws_security_group" "staging-vpc-sg" {
  name        = "Terraform SG for Concourse VPC"
  description = "Virtual Private Cloud Security Group for Concourse CI terraform"
  vpc_id      = "${aws_vpc.staging.id}"

  # HTTP access from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTP access to app from allowed IPs
  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = "${var.allow_ips}"
  }

  # postgresql access from allowed IPs
  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = "${var.allow_ips}"
  }

  # mongo access from allowed IPs
  ingress {
    from_port   = 27017
    to_port     = 27017
    protocol    = "tcp"
    cidr_blocks = "${var.allow_ips}"
  }

  # HTTPS access from anywhere
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # SSH access from allowed IPs
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = "${var.allow_ips}"
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
