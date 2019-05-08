#!/bin/bash

# install dependencies
sudo yum update -y
sudo yum install epel-release -y
sudo yum install yum-utils -y
sudo yum install nginx -y
sudo systemctl start nginx
sudo systemctl enable nginx

sudo yum install git python-pip -y

# add docker repo
sudo cat >/etc/yum.repos.d/docker.repo <<-EOF
[dockerrepo]
name=Docker Repository
baseurl=https://yum.dockerproject.org/repo/main/centos/7
enabled=1
gpgcheck=1
gpgkey=https://yum.dockerproject.org/gpg
EOF

sudo yum install docker-engine -y
sudo systemctl enable docker
sudo systemctl start docker
sudo pip install docker-compose

sudo pip install awscli

mkdir -p /usr/local/share/bchd

cd /usr/local/share/bchd

aws s3 cp s3://bchd-configs/prod-secrets secrets.sh
aws s3 cp s3://bchd-configs/watchmaker config.yml
aws s3 cp s3://bchd-configs/prod-dashboardconfig config/healthdashboard.conf

# install and run watchmaker
git clone https://github.com/plus3it/watchmaker.git --recursive && cd watchmaker
git submodule update --init --recursive
git checkout 0.5.1
pip install .

#watchmaker --config /usr/local/share/bchd/config.yml
