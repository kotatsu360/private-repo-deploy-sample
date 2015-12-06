#
# Cookbook Name:: private-repo-clone
# Recipe:: default
#
# Copyright 2015, Tatsuro Mitsuno
#
# All rights reserved - Do Not Redistribute
#

include_recipe "git"

file "/etc/sudoers.d/root_ssh_agent" do
  mode 0440
  owner 'root'
  group 'root'
  content "Defaults env_keep += \"SSH_AUTH_SOCK\"\n"
end

bash "add ssh_setting to .ssh/config" do
  not_if %!grep Host github.com /root/.ssh/config!

  code <<-EOC
    echo -e "Host github.com\n StrictHostKeyChecking no\n" >> /root/.ssh/config
  EOC
end

git "./private-repo" do
  repository "git@github.com:kotatsu360/private-repo-deploy-sample.git"
  action :sync  
end
