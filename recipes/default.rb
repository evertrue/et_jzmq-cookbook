#
# Cookbook Name:: et_jzmq
# Recipe:: default
#
# Copyright (C) 2013 EverTrue, Inc.
#
# All rights reserved - Do Not Redistribute
#

node.set['java']['jdk_version'] = "7"

case node['platform_family']
  when "debian"
   include_recipe "apt"
end

include_recipe "build-essential"
include_recipe "java"

node.set['zeromq']['src_version'] = "2.1.7"
node.set['zeromq']['src_mirror'] = "http://download.zeromq.org/zeromq-#{node['zeromq']['src_version']}.tar.gz"
node.set['zeromq']['install_dir'] = "/usr/local"

include_recipe "zeromq"

package 'pkg-config'
package 'libtool'

execute "install_jzmq" do
  cwd "#{Chef::Config[:file_cache_path]}/#{cookbook_name.to_s}"
  command "./autogen.sh && " +
    "./configure " +
    "--prefix=#{node['et_jzmq']['install_dir']} " +
    "--with-zeromq=#{node['zeromq']['install_dir']} && " +
    "make && " +
    "make install"
  action :nothing
end

git "#{Chef::Config[:file_cache_path]}/#{cookbook_name.to_s}" do
  repository node['et_jzmq']['git_repo']
  reference node['et_jzmq']['git_reference']
  notifies :run, "execute[install_jzmq]"
end

execute "run_ldconfig" do
  command "ldconfig"
  action :nothing
end

file "/etc/ld.so.conf.d/jzmq.conf" do
  content File.join(node['et_jzmq']['install_dir'], "lib")
  only_if { node['platform_family'] == "debian" }
  notifies :run, "execute[run_ldconfig]"
end
