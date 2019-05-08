provider "aws" {
  region = "${var.region}"
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
}

# "web: ${aws_instance.prod-web.public_ip}",
# "db: ${aws_instance.prod-db.public_ip}",

#TODO: get this to work without having to specify the instances explicitly
output "public_ips" {
  value = [
    "staging: ${aws_instance.staging.public_ip}"
  ]
}

resource "aws_instance" "staging" {
  ami = "ami-cd0f5cb6"
  instance_type = "t2.small"

  #TODO: this needs to be set as an environment variable
  key_name = "${var.keypair}"

  # add iam role from above
  iam_instance_profile = "${aws_iam_instance_profile.staging-bchd-ec2-role.name}"

  # Our Security group to allow HTTP access
  vpc_security_group_ids = ["${aws_security_group.staging-vpc-sg.id}"]

  subnet_id = "${aws_subnet.staging.id}"
  user_data = "${file("./userdata_staging.sh")}"
}

# resource "aws_instance" "prod-web" {
#   ami = "ami-cd0f5cb6"
#   instance_type = "t2.micro"
#
#   key_name = "${var.keypair}"
#
#   # add iam role from above
#   iam_instance_profile = "${aws_iam_instance_profile.prod-bchd-ec2-role.name}"
#
#   # Our Security group to allow HTTP access
#   vpc_security_group_ids = ["${aws_security_group.prod-vpc-sg.id}"]
#
#   subnet_id = "${aws_subnet.prod.id}"
#   user_data = "${file("./userdata_prod_web.sh")}"
# }
#
# resource "aws_instance" "prod-db" {
#   ami = "ami-cd0f5cb6"
#   instance_type = "t2.small"
#
#   key_name = "${var.keypair}"
#
#   # add iam role from above
#   iam_instance_profile = "${aws_iam_instance_profile.prod-bchd-ec2-role.name}"
#
#   # Our Security group to allow HTTP access
#   vpc_security_group_ids = ["${aws_security_group.prod-vpc-sg.id}"]
#
#   subnet_id = "${aws_subnet.prod.id}"
#   user_data = "${file("./userdata_prod_db.sh")}"
# }
