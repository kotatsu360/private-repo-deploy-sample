#!/bin/bash

ls ~/.ssh

if [ ! -d ~/pkgs ]; then
    mkdir ~/pkgs
fi

if [ ! -f ~/pkgs/vagrant.deb ]; then
    wget -O ~/pkgs/vagrant.deb https://releases.hashicorp.com/vagrant/1.7.4/vagrant_1.7.4_x86_64.deb
fi
sudo dpkg -i ~/pkgs/vagrant.deb

BOX_NAME=dummy
if [ ! -d ~/.vagrant.d/boxes/$BOX_NAME ]; then
    vagrant box add $BOX_NAME https://github.com/mitchellh/vagrant-aws/raw/master/dummy.box
fi

if [ ! -f ~/.vagrant.d/plugins.json ]; then
    vagrant plugin install vagrant-aws vagrant-omnibus vagrant-berkshelf
fi

if [ ! -f ~/pkgs/chefdf.deb ]; then
    wget -O ~/pkgs/chefdf.deb https://opscode-omnibus-packages.s3.amazonaws.com/ubuntu/12.04/x86_64/chefdk_0.10.0-1_amd64.deb  
fi
sudo dpkg -i ~/pkgs/chefdf.deb

sudo pip install awscli
echo "Host nat" >> ~/.ssh/config
echo "  Hostname ${AWS_NAT_SERVER_IP_ADDRESS}" >> ~/.ssh/config
echo "  User ec2-user" >> ~/.ssh/config
