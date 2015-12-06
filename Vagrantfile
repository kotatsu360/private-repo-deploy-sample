# -*- coding: utf-8 -*-
# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.box = "dummy"
  config.ssh.pty = true
  config.ssh.forward_agent = true
  config.vm.synced_folder ".", "/vagrant", disabled: true

  config.vm.provider :aws do |aws, override|

    aws.tags = { 'Name' => 'test' }

    aws.access_key_id = ENV['AWS_ACCESS_KEY_ID']
    aws.secret_access_key = ENV['AWS_SECRET_ACCESS_KEY'];
    aws.region = ENV['AWS_DEFAULT_REGION']

    aws.keypair_name = ENV['AWS_KEYPAIR']
    override.ssh.proxy_command = "ssh -A nat -W %h:%p"
    override.ssh.private_key_path = [ENV['GITHUB_CLONE_SSH_KEY_PATH'], ENV['AWS_LOGIN_SSH_KEY_PATH']]
    
    aws.instance_type = "t2.micro"

    # Ubuntu Server 14.04 LTS (HVM), SSD Volume Type
    aws.ami = "ami-5189a661"
    override.ssh.username = "ubuntu"

    # [NOTE] インスタンスをデプロイしたいsubnet
    aws.subnet_id = ENV['AWS_DEPLOY_SUBNET']
    aws.security_groups = ENV['AWS_DEPLOY_MACHINE_SECURITY_GROUP']
  end

  config.vm.provision :chef_solo do |chef|
    chef.add_recipe "private-repo-clone::default"
  end

  config.berkshelf.berksfile_path = "./sample/Berksfile"
  config.berkshelf.enabled = true
  config.omnibus.chef_version = '12.5.1'
end
