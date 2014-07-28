#
# Author::  Seth Chisamore (<schisamo@opscode.com>)
# Cookbook Name:: php-fpm
# Recipe:: package
#
# Copyright 2011, Opscode, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

::Chef::Recipe.send(:include, ::PhpFpm::Helpers)

include_recipe 'php-fpm::repository' unless node['php-fpm']['skip_repository_install']

if node['php-fpm']['package_name'].nil?
  if platform_family?('rhel')
    php_fpm_package_name = 'php-fpm'
  else
    php_fpm_package_name = 'php5-fpm'
  end
else
  php_fpm_package_name = node['php-fpm']['package_name']
end

package php_fpm_package_name do
  action :upgrade
end

node.default['php-fpm']['service'] = php_fpm_package_name if node['php-fpm']['service'].nil?

if ubuntu13xm?
  service 'php-fpm' do
    service_name node['php-fpm']['service']
    provider ::Chef::Provider::Service::Upstart
    supports start: true, stop: true, restart: true, reload: true
    action [:enable, :start]
  end
else
  service 'php-fpm' do
    service_name node['php-fpm']['service']
    supports start: true, stop: true, restart: true, reload: true
    action [:enable, :start]
  end
end
