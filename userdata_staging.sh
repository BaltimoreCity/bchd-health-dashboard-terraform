#!/bin/bash

# install dependencies
sudo apt-get update -y

sudo apt-get install software-properties-common -y
sudo apt-add-repository ppa:ansible/ansible -y
sudo apt-get update -y
sudo apt-get install ansible python-pip python-dev build-essential -y
sudo pip install --upgrade pip

ansible-galaxy install bbatsche.MongoDB-Install
ansible-galaxy install geerlingguy.docker
ansible-galaxy install geerlingguy.git
ansible-galaxy install geerlingguy.nginx
ansible-galaxy install geerlingguy.postgresql
ansible-galaxy install geerlingguy.nodejs

sudo pip install awscli

mkdir -p /usr/local/share/tf
cd /usr/local/share/tf

aws s3 cp s3://bchd-configs/staging-secrets secrets.sh
aws s3 cp s3://bchd-configs/staging-playbook playbook.yml



source ./secrets.sh && sudo ansible-playbook -i "localhost," -c local playbook.yml

groupadd web

useradd web -g web -m -d /home/web -k /etc/skel -s /bin/bash

mkdir -p /usr/local/share/bchd

chown web:web /usr/local/share/bchd

cd /usr/local/share/bchd/config
aws s3 cp s3://bchd-configs/staging-dashboardconfig healthdashboard.conf

cd /home/web

mkdir .ssh

chown web:web .ssh
chmod 700 .ssh

cd .ssh

aws s3 cp s3://bchd-configs/authorized_keys authorized_keys

chown web:web authorized_keys
chmod 600 authorized_keys

cd /etc/systemd/system

aws s3 cp s3://bchd-configs/mongo-service mongodb.service

sudo systemctl start mongodb
sudo systemctl enable mongodb
