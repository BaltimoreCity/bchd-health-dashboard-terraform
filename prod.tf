# resource "aws_vpc" "prod" {
#   cidr_block = "10.0.0.0/16"
# }
#
# resource "aws_internet_gateway" "prod" {
#   vpc_id = "${aws_vpc.prod.id}"
# }
#
# resource "aws_route" "prod_internet_access" {
#   route_table_id         = "${aws_vpc.prod.main_route_table_id}"
#   destination_cidr_block = "0.0.0.0/0"
#   gateway_id             = "${aws_internet_gateway.prod.id}"
# }
#
# resource "aws_subnet" "prod" {
#   vpc_id                  = "${aws_vpc.prod.id}"
#   cidr_block              = "10.0.2.0/24"
#   map_public_ip_on_launch = true
# }
#
# resource "aws_security_group" "prod-vpc-sg" {
#   name        = "Terraform SG for Concourse VPC"
#   description = "Virtual Private Cloud Security Group for Concourse CI terraform"
#   vpc_id      = "${aws_vpc.prod.id}"
#
#   # HTTP access from anywhere
#   ingress {
#     from_port   = 80
#     to_port     = 80
#     protocol    = "tcp"
#     cidr_blocks = ["10.0.0.0/16"]
#   }
#
#   # HTTP access from vpc
#   ingress {
#     from_port   = 8080
#     to_port     = 8080
#     protocol    = "tcp"
#     cidr_blocks = ["10.0.0.0/16"]
#   }
#
#   # HTTP access from vpc
#   ingress {
#     from_port   = 8080
#     to_port     = 8080
#     protocol    = "tcp"
#     cidr_blocks = ["10.0.0.0/16"]
#   }
#
#   # HTTPS access from vpc
#   ingress {
#     from_port   = 443
#     to_port     = 443
#     protocol    = "tcp"
#     cidr_blocks = ["10.0.0.0/16"]
#   }
#
#   # SSH access from the anywhere
#   ingress {
#     from_port   = 22
#     to_port     = 22
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
#
#   # outbound internet access
#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }
#
# resource "aws_security_group" "prod-elb-sg" {
#   name        = "Terraform SG for Concourse ELB"
#   description = "Elastic Load Balancer Security Group for Concourse CI terraform"
#   vpc_id      = "${aws_vpc.prod.id}"
#
#   # HTTP access from anywhere
#   ingress {
#     from_port   = 80
#     to_port     = 80
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
#
#   # HTTP access from anywhere
#   ingress {
#     from_port   = 8080
#     to_port     = 8080
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
#
#   # HTTPS access from anywhere
#   ingress {
#     from_port   = 443
#     to_port     = 443
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
#
#   # outbound internet access
#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }
#
# resource "aws_elb" "prod" {
#   name = "prod"
#
#   subnets         = ["${aws_subnet.prod.id}"]
#   security_groups = ["${aws_security_group.prod-elb-sg.id}"]
#   instances       = ["${aws_instance.prod-web.id}"]
#
#   health_check {
#     healthy_threshold   = 2
#     unhealthy_threshold = 2
#     timeout             = 3
#     target              = "HTTP:80/"
#     interval            = 5
#   }
#
#   listener {
#     instance_port     = 80
#     instance_protocol = "http"
#     lb_port           = 80
#     lb_protocol       = "http"
#   }
#
#   listener {
#     instance_port     = 8080
#     instance_protocol = "http"
#     lb_port           = 8080
#     lb_protocol       = "http"
#   }
#
#   listener {
#     instance_port     = 22
#     instance_protocol = "tcp"
#     lb_port           = 22
#     lb_protocol       = "tcp"
#   }
# }
#
# output "prod-elb" {
#   value = "${aws_elb.prod.dns_name}"
# }
