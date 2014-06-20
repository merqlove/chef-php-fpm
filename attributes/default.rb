if node.platform_family == "rhel"
  user = "apache"
  group = "apache"
  conf_dir = "/etc/php.d"
  pool_conf_dir = "/etc/php-fpm.d"
  conf_file = "/etc/php-fpm.conf"
  error_log = "/var/log/php-fpm/error.log"
  pid = "/var/run/php-fpm/php-fpm.pid"
else
  user = "www-data"
  group = "www-data"
  conf_dir = "/etc/php5/fpm/conf.d"
  pool_conf_dir = "/etc/php5/fpm/pool.d"
  if node.platform == "ubuntu" and node.platform_version.to_f <= 10.04
    conf_file = "/etc/php5/fpm/php5-fpm.conf"
  else
    conf_file = "/etc/php5/fpm/php-fpm.conf"
  end
  error_log = "/var/log/php5-fpm.log"
  pid ="/var/run/php5-fpm.pid"
end

if platform_family?("rhel")
  default['php-fpm']['service'] = "php-fpm"
else
  default['php-fpm']['service'] = "php5-fpm"
end

default['php-fpm']['user'] = user
default['php-fpm']['group'] = group
default['php-fpm']['conf_dir'] = conf_dir
default['php-fpm']['pool_conf_dir'] = pool_conf_dir
default['php-fpm']['conf_file'] = conf_file
default['php-fpm']['pid'] = pid
default['php-fpm']['error_log'] =  error_log
default['php-fpm']['log_level'] = "notice"
default['php-fpm']['upload_max_filesize'] = "16M"
default['php-fpm']['post_max_size'] = "16M"

default['php-fpm']['session_save_path'] = "/var/lib/php/session"
default['php-fpm']['session_save_handler'] = "files"

default['php-fpm']['emergency_restart_threshold'] = 10
default['php-fpm']['emergency_restart_interval'] = "1m"
default['php-fpm']['process_control_timeout'] = "10s"

default['php-fpm']['default']['pool'] = {
  allowed_clients: "127.0.0.1",
  process_manager: "dynamic",
  max_children: 4,
  start_servers: 2,
  min_spare_servers: 1,
  max_spare_servers: 3,
  max_requests: 200,
  catch_workers_output: "yes",            
  request_slowlog_timeout: "5s",      
  backlog: "-1",
  rlimit_files: "131072",
  rlimit_core: "unlimited"
}

# default['php-fpm']['pool']['www']['listen'] = "/var/run/php-fpm-www.sock"
# default['php-fpm']['pool']['www']['allowed_clients'] = ["127.0.0.1"]
# default['php-fpm']['pool']['www']['user'] = user
# default['php-fpm']['pool']['www']['group'] = group
# default['php-fpm']['pool']['www']['process_manager'] = "dynamic"
# default['php-fpm']['pool']['www']['max_children'] = 5
# default['php-fpm']['pool']['www']['start_servers'] = 3
# default['php-fpm']['pool']['www']['min_spare_servers'] = 2
# default['php-fpm']['pool']['www']['max_spare_servers'] = 4
# default['php-fpm']['pool']['www']['max_requests'] = 200
# default['php-fpm']['pool']['www']['catch_workers_output'] = "no"
# default['php-fpm']['pool']['www']['request_slowlog_timeout'] = "5s"
# default['php-fpm']['pool']['www']['slowlog'] = "/var/log/php-fpm/slowlog-www.log"
# default['php-fpm']['pool']['www']['backlog'] = "-1"
# default['php-fpm']['pool']['www']['rlimit_files'] = "131072"
# default['php-fpm']['pool']['www']['rlimit_core'] = "unlimited"
# default['php-fpm']['pool']['www']['session_save_path'] = "/var/lib/php/session"
# default['php-fpm']['pool']['www']['session_save_handler'] = "files"

default['php-fpm']['emergency_restart_threshold'] = 0
default['php-fpm']['emergency_restart_interval'] = 0
default['php-fpm']['process_control_timeout'] = 0
default['php-fpm']['pools'] = [
  {
    :name => "www"
  }
]

default['php-fpm']['yum_url'] = "http://rpms.famillecollet.com/enterprise/$releasever/remi/$basearch/"
default['php-fpm']['yum_mirrorlist'] = "http://rpms.famillecollet.com/enterprise/$releasever/remi/mirror"
