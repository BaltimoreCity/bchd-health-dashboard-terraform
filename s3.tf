resource "aws_s3_bucket" "logging" {
  bucket = "bchd-logging"
  acl    = "log-delivery-write"
  force_destroy = true
}

resource "aws_s3_bucket" "configs" {
  bucket = "bchd-configs"
  acl    = "private"

  tags {
    Name = "configs"
  }

  logging {
    target_bucket = "${aws_s3_bucket.logging.id}"
    target_prefix = "log/"
  }
}

resource "aws_s3_bucket_object" "mongo-service" {
  bucket = "${aws_s3_bucket.configs.id}"
  key    = "mongo-service"
  source = "configs/mongodb.service"
  etag   = "${md5(file("configs/mongodb.service"))}"
}

resource "aws_s3_bucket_object" "staging-playbook" {
  bucket = "${aws_s3_bucket.configs.id}"
  key    = "staging-playbook"
  source = "configs/staging-playbook.yml"
  etag   = "${md5(file("configs/staging-playbook.yml"))}"
}

resource "aws_s3_bucket_object" "staging-dashboardconfig" {
  bucket = "${aws_s3_bucket.configs.id}"
  key    = "staging-dashboardconfig"
  source = "configs/staging-healthdashboard.conf"
  etag   = "${md5(file("configs/staging-healthdashboard.conf"))}"
}

resource "aws_s3_bucket_object" "prod-dashboardconfig" {
  bucket = "${aws_s3_bucket.configs.id}"
  key    = "prod-dashboardconfig"
  source = "configs/prod-healthdashboard.conf"
  etag   = "${md5(file("configs/prod-healthdashboard.conf"))}"
}

resource "aws_s3_bucket_object" "authorized_keys" {
  bucket = "${aws_s3_bucket.configs.id}"
  key    = "authorized_keys"
  source = "configs/authorized_keys"
  etag   = "${md5(file("configs/authorized_keys"))}"
}

resource "aws_s3_bucket_object" "dev-secret-env" {
  bucket = "${aws_s3_bucket.configs.id}"
  key    = "staging-secrets"
  source = "configs/staging-secrets.sh"
  etag   = "${md5(file("configs/staging-secrets.sh"))}"
}

resource "aws_s3_bucket_object" "secret-env" {
  bucket = "${aws_s3_bucket.configs.id}"
  key    = "prod-secrets"
  source = "configs/prod-secrets.sh"
  etag   = "${md5(file("configs/prod-secrets.sh"))}"
}
