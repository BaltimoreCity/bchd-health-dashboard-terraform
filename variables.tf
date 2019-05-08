variable "access_key" {}
variable "secret_key" {}
variable "region" {
  default = "us-east-1"
}
variable "keypair" {}

variable "allow_ips" {
  default = [
    "10.0.1.0/24", # internal addresses
  ]
}
