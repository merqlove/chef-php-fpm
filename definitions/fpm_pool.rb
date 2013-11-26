#
# Cookbook Name:: php-fpm
# Definition:: fpm_pool
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

define :fpm_pool, :template => "pool.conf.erb", :enable => true do

  pool_name = params[:name]

  include_recipe "php-fpm"

  conf_file = "#{node['php-fpm']['conf_dir']}/pools/#{pool_name}.conf"
  # /etc/php5/fpm/pool.d/www.conf
  template conf_file do
    only_if "test -d #{node['php-fpm']['conf_dir']}/pools || mkdir -p #{node['php-fpm']['conf_dir']}/pools"
    source params[:template]
    owner "root"
    group "root"
    mode 00644
    if params[:cookbook]
      cookbook params[:cookbook]
    end
    variables(
    :pool_name => pool_name,
    :listen => node['php-fpm']['pool'][pool_name]['listen'],
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
    :slowlog => node['php-fpm']['pool'][pool_name]['slowlog'],
    :backlog => node['php-fpm']['pool'][pool_name]['backlog'],
    :rlimit_files => node['php-fpm']['pool'][pool_name]['rlimit_files'],
    :rlimit_core => node['php-fpm']['pool'][pool_name]['rlimit_core'],
    :params => params
    )
    notifies :restart, "service[#{node['php-fpm']['service']}]"
  end
end
