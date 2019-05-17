<p align="center"><img height="100" src="https://fearless.cdn.prismic.io/fearless/cac1a3692f0048f3365555e82090e41bf0f7521b_cs-bchd-logo.jpg"><img height="100" src="https://fearless.cdn.prismic.io/fearless/50b39d99b1e2e16b3e9004fee7dca723b7ed555e_cs-bchd-logo2.png"></p>

<h1 align="center">BCHD Health Dashboard Terraform Plan</h1>

<h2 align="center">A definition and state for the infrastructure of the BCHD Health Dashboard.</h2>

<p align="center">
  <a href="https://www.gnu.org/licenses/gpl-3.0" target="blank"><img src="https://img.shields.io/badge/License-GPLv3-blue.svg"></a>
  <a href="https://github.com/ellerbrock/open-source-badges/" target="blank"><img src="https://badges.frapsoft.com/os/v1/open-source.svg?v=103"></a>
 </p>

<p align="center">
  <a href=#purpose>Purpose</a> • 
  <a href=#background>Background</a> • 
  <a href=#dependencies>Dependencies</a> • 
  <a href=#structure>Structure</a> • 
  <a href=#usage>Usage</a> • 
  <a href=#contributors>Contributors</a> • 
  <a href=#license>License</a> 
</p>

## Purpose

The intended purpose of this project is to provide a definition and state for the infrastructure of the Baltimore City Health Department (BCHD) Health Dashboard.

## Background
In 2016, the <a href="https://health.baltimorecity.gov/news/press-releases/2017-03-03-baltimore-city-health-department-launches-new-civic-innovation-0" target="_blank">BCHD</a> launched the TECHealth program and innovation fund with the goal of using technology to better understand and address health disparities in the city. As a grant awardee and member of the TECHealth cohort, <a href="http://fearless.tech" target="blank">Fearless</a> created a dashboard for BCHD to track public health trends and correlate them with environmental and social factors. For more context and to view the code for the dashboard, visit the repository <a href="https://github.com/BaltimoreCity/bchd-health-dashboard" target="blank">here</a>.

## Dependencies

* <a href="https://aws.amazon.com/cli/" target="blank">AWS CLI</a>
* AWS access tokens:
 * These need to be defined within `env.tfvars`,  this can be copied from `env.tfvars.example`, and you'll need to modify the file to match your credentials
 * NEVER CHECK `env.tfvars` INTO GIT HISTORY!!!
 * These details can be gathered using the AWS api, and the user requires access to be able to do the following:
   * Create IAM roles/role profiles
   * Create S3 buckets
   * Full EC2 access
 * It also requires an existing keypair in AWS which can be defined in `env.tfvars`
* <a href="https://www.terraform.io/downloads.html" target="blank">Terraform</a>


## Structure

* variables.tf - Defines variables to be used to connect to the provider
* iam.tf - Defines IAM roles and role profiles for all instances to access S3 buckets containing configuration files
* s3.tf - Define a private S3 bucket with a logging bucket to log activity, private bucket will contain configuration files for instances
* staging.tf - Network configuration for staging node, open access to necessary ports for development
* prod.tf - Network configuration for production node, restricted access with web/ssh ports being exposed over ELB
* userdata - These will provision the server with necessary application dependencies for deployment
* main.tf - Provisions nodes and ties in previously defined resources, assignment of AMI for instance provisioning and appropriate assignment of userdata per node

## Usage

### First and foremost, be very cautious what you do. Terraform can and will tear down existing infrastructure if changes are made to userdata or instances. You've been warned.

* Set your values for a few config variables:
  * variables.tf contains a variable named allow_ips which lists all IPs that should be whitelisted for SSH, Mongo, Postgres, and HTTP port 3000 access to the staging environment. This is a quoted, comma-separated list in CIDR notation. It should be overridden in your env.tfvars file
  * configs/authorized_keys contains a list of RSA public keys which are authorized to SSH into the environment. The format is the same as a Unix/Linux SSH authorized_keys file. Ideally, there should be a comment before each public key with the name of its owner for auditing purposes.
  * There are several environment variables used by the dashboard application that will need to be set. The files for staging and production are staging-secrets.sh and prod-secrets.sh respectively. Examples showing exactly what variables need to be set are found in staging-secrets.sh.example and prod-secrets.sh.example. Any changes to local copies of the secrets files will be pushed to S3 when `terraform apply` is run.
* To test that you've configured things properly run `terraform plan --var-file='env.tfvars'`
* Once confirmed that everything is configured, you can then run `terraform apply --var-file='env.tfvars'`

### Notes

EC2 AMI used chosen using guide provided by Ubuntu: https://help.ubuntu.com/community/EC2StartersGuide

For future thought if need be: https://askubuntu.com/questions/53582/how-do-i-know-what-ubuntu-ami-to-launch-on-ec2

## Contributors
<a href="https://github.com/lsamuels-fearless" target="blank"><img src="https://avatars0.githubusercontent.com/u/43243765?s=460&v=4" width="100px;"/></a>
<a href="https://github.com/thetif" target="blank"><img src="https://avatars3.githubusercontent.com/u/62778?s=460&v=4" width="100px;"/></a>

## License
<a href="https://www.gnu.org/licenses/gpl-3.0" target="blank">GNU General Public License v3.0</a>
