#
# Cookbook Name:: php-fpm
# Definition:: php_fpm_pool
#
# Copyright 2008-2009, Opscode, Inc.
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

define :php_fpm_pool, :template => "pool.conf.erb", :enable => true do

  pool_name = params[:name]

  include_recipe "php-fpm"

  conf_file = "#{node['php-fpm']['pool_conf_dir']}/#{pool_name}.conf"

  if params[:enable]
    template conf_file do
      only_if "test -d #{node['php-fpm']['pool_conf_dir']} || mkdir -p #{node['php-fpm']['pool_conf_dir']}"
      source params[:template]
      owner "root"
      group "root"
      mode 00644
      cookbook params[:cookbook] || "php-fpm"
      variables(
        :pool_name => pool_name,
        :listen => node['php-fpm']['pool'][pool_name]['listen'],
        :listen_owner => node['php-fpm']['pool'][pool_name]['listen_owner'] || node['php-fpm']['listen_owner'],
        :listen_group => node['php-fpm']['pool'][pool_name]['listen_group'] || node['php-fpm']['listen_group'],
        :listen_mode => node['php-fpm']['pool'][pool_name]['listen_mode'] || node['php-fpm']['listen_mode'],
        :allowed_clients => node['php-fpm']['pool'][pool_name]['allowed_clients'],
        :user => node['php-fpm']['pool'][pool_name]['user'],
        :group => node['php-fpm']['pool'][pool_name]['group'],
        :process_manager => node['php-fpm']['pool'][pool_name]['process_manager'],
        :max_children => node['php-fpm']['pool'][pool_name]['max_children'],
        :start_servers => node['php-fpm']['pool'][pool_name]['start_servers'],
        :min_spare_servers => node['php-fpm']['pool'][pool_name]['min_spare_servers'],
        :max_spare_servers => node['php-fpm']['pool'][pool_name]['max_spare_servers'],
        :max_requests => node['php-fpm']['pool'][pool_name]['max_requests'],
        :catch_workers_output => node['php-fpm']['pool'][pool_name]['catch_workers_output'],
        :sendmail_path => node['php-fpm']['pool'][pool_name]['sendmail_path'],
        :memory_limit => node['php-fpm']['pool'][pool_name]['memory_limit'],
        :session_save_handler => node['php-fpm']['pool'][pool_name]['session_save_handler'],
        :session_save_path => node['php-fpm']['pool'][pool_name]['session_save_path'],
        :request_slowlog_timeout => node['php-fpm']['pool'][pool_name]['request_slowlog_timeout'],
        :error_log => node['php-fpm']['pool'][pool_name]['error_log'],
        :slowlog => node['php-fpm']['pool'][pool_name]['slowlog'],
        :backlog => node['php-fpm']['pool'][pool_name]['backlog'],
        :production => node['php-fpm']['pool'][pool_name]['production'],
        :rlimit_files => node['php-fpm']['pool'][pool_name]['rlimit_files'],
        :rlimit_core => node['php-fpm']['pool'][pool_name]['rlimit_core'],
        :security_limit_extensions => node['php-fpm']['pool'][pool_name]['security_limit_extensions'] || node['php-fpm']['security_limit_extensions'],
        :php_options => node['php-fpm']['pool'][pool_name]['php_options'] || {},
        :params => params
      )
      notifies :restart, "service[#{node['php-fpm']['service']}]"
    end
  else
    cookbook_file conf_file do
      action :delete
      notifies :restart, "service[#{node['php-fpm']['service']}]"
    end
  end
end
