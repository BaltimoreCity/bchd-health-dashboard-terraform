# Baltimore City Health Department - Health Dashboard Terraform Plan

## Purpose

The intended purpose of this project is to provide a definition and state for the infrastructure of the BCHD Health Dashboard.

## Dependencies

* AWS cli - https://aws.amazon.com/cli/
* AWS access tokens:
 * These need to be defined within `env.tfvars`,  this can be copied from `env.tfvars.example`, and you'll need to modify the file to match your credentials
 * NEVER CHECK `env.tfvars` INTO GIT HISTORY!!!
 * these details can be gathered using the AWS api, and the user requires access to be able to do the following:
   * Create IAM roles/role profiles
   * Create S3 buckets
   * Full EC2 access
 * it also requires an existing keypair in AWS which can be defined in `env.tfvars`
* terraform - https://www.terraform.io/downloads.html


## Structure

* variables.tf - Defines variables to be used to connect to the provider
* iam.tf - Defines IAM roles and role profiles for all instances to access S3 buckets containing configuration files
* s3.tf - Define a private S3 bucket with a logging bucket to log activity, private bucket will contain configuration files for instances
* staging.tf - Network configuration for staging node, open access to necessary ports for development
* prod.tf - Network configuration for production node, restricted access with web/ssh ports being exposed over ELB
* userdata - These will provision the server with necessary application dependencies for deployment
* main.tf - provisions nodes and ties in previously defined resources, assignment of AMI for instance provisioning and appropriate assignment of userdata per node

## Usage

### First and foremost, be very cautious what you do
### terraform can and will tear down existing infrastructure if changes are made to userdata, or instances... You've been warned

* Set your values for a few config variables:
  * variables.tf contains a variable named allow_ips which lists all IPs that should be whitelisted for SSH, Mongo, Postgres, and HTTP port 3000 access to the staging environment. This is a quoted, comma-separated list in CIDR notation. It should be overridden in your env.tfvars file
  * configs/authorized_keys contains a list of RSA public keys which are authorized to SSH into the environment. The format is the same as a Unix/Linux SSH authorized_keys file. Ideally, there should be a comment before each public key with the name of its owner for auditing purposes.
  * There are several environment variables used by the dashboard application that will need to be set. The files for staging and production are staging-secrets.sh and prod-secrets.sh respectively. Examples showing exactly what variables need to be set are found in staging-secrets.sh.example and prod-secrets.sh.example. Any changes to local copies of the secrets files will be pushed to S3 when `terraform apply` is run.
* To test that you've configured things properly run `terraform plan --var-file='env.tfvars'`
* Once confirmed that everything is configured, you can then run `terraform apply --var-file='env.tfvars'`

### notes:

EC2 AMI used chosen using guide provided by Ubuntu: https://help.ubuntu.com/community/EC2StartersGuide

For future thought if need be: https://askubuntu.com/questions/53582/how-do-i-know-what-ubuntu-ami-to-launch-on-ec2
