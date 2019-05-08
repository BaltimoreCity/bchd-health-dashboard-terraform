resource "aws_iam_role" "bchd-ec2-role" {
  name = "bchd-ec2-role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
  EOF
}

resource "aws_iam_instance_profile" "prod-bchd-ec2-role" {
  name = "prod-bchd-ec2-role"
  role = "${aws_iam_role.bchd-ec2-role.name}"
}

resource "aws_iam_instance_profile" "staging-bchd-ec2-role" {
  name = "staging-bchd-ec2-role"
  role = "${aws_iam_role.bchd-ec2-role.name}"
}

resource "aws_iam_role_policy" "prod-bchd-ec2-role-policy" {
  name = "prod-bchd-ec2-role-policy"
  role = "${aws_iam_role.bchd-ec2-role.id}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:*"
            ],
            "Resource": [
              "arn:aws:s3:::${aws_s3_bucket.configs.id}",
              "arn:aws:s3:::${aws_s3_bucket.configs.id}/prod-*"
            ]
        }, {
          "Effect": "Allow",
          "Action": "s3:ListAllMyBuckets",
          "Resource": "arn:aws:s3:::*"
        }
    ]
}
  EOF
}

resource "aws_iam_role_policy" "staging-bchd-ec2-role-policy" {
  name = "staging-bchd-ec2-role-policy"
  role = "${aws_iam_role.bchd-ec2-role.id}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:*"
            ],
            "Resource": [
              "arn:aws:s3:::${aws_s3_bucket.configs.id}",
              "arn:aws:s3:::${aws_s3_bucket.configs.id}/staging-*",
              "arn:aws:s3:::${aws_s3_bucket.configs.id}/authorized_keys",
              "arn:aws:s3:::${aws_s3_bucket.configs.id}/mongo-service"
            ]
        }, {
          "Effect": "Allow",
          "Action": "s3:ListAllMyBuckets",
          "Resource": "arn:aws:s3:::*"
        }
    ]
}
  EOF
}
