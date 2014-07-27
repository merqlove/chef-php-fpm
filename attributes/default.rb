if node.platform_family == 'rhel'
  user = 'apache'
  group = 'apache'
  conf_dir = '/etc/php.d'
  pool_conf_dir = '/etc/php-fpm.d'
  conf_file = '/etc/php-fpm.conf'
  error_log = '/var/log/php-fpm/error.log'
  pid = '/var/run/php-fpm/php-fpm.pid'
else
  user = 'www-data'
  group = 'www-data'
  conf_dir = '/etc/php5/fpm/conf.d'
  pool_conf_dir = '/etc/php5/fpm/pool.d'
  if node.platform == 'ubuntu' && node.platform_version.to_f <= 10.04
    conf_file = '/etc/php5/fpm/php5-fpm.conf'
  else
    conf_file = '/etc/php5/fpm/php-fpm.conf'
  end
  error_log = '/var/log/php5-fpm.log'
  pid = '/var/run/php5-fpm.pid'
end

if platform_family?('rhel')
  default['php-fpm']['service'] = 'php-fpm'
else
  default['php-fpm']['service'] = 'php5-fpm'
end

default['php-fpm']['user'] = user
default['php-fpm']['group'] = group
default['php-fpm']['conf_dir'] = conf_dir
default['php-fpm']['pool_conf_dir'] = pool_conf_dir
default['php-fpm']['conf_file'] = conf_file
default['php-fpm']['pid'] = pid
default['php-fpm']['error_log'] =  error_log
default['php-fpm']['log_level'] = 'notice'
default['php-fpm']['upload_max_filesize'] = '16M'
default['php-fpm']['post_max_size'] = '16M'

default['php-fpm']['session_save_path'] = '/var/lib/php/session'
default['php-fpm']['session_save_handler'] = 'files'

default['php-fpm']['emergency_restart_threshold'] = 10
default['php-fpm']['emergency_restart_interval'] = '1m'
default['php-fpm']['process_control_timeout'] = '10s'

default['php-fpm']['default']['pool'] = {
  name: 'www',
  allowed_clients: '127.0.0.1',
  process_manager: 'dynamic',
  max_children: 4,
  start_servers: 2,
  min_spare_servers: 1,
  max_spare_servers: 3,
  max_requests: 200,
  catch_workers_output: 'yes',
  php_options: {
    'listen.backlog' => '-1',
    'rlimit_files' => '131072',
    'rlimit_core' => 'unlimited'
  }
}

default['php-fpm']['emergency_restart_threshold'] = 0
default['php-fpm']['emergency_restart_interval'] = 0
default['php-fpm']['process_control_timeout'] = 0
default['php-fpm']['pools'] = [
  {
    name: 'www'
  }
]

default['php-fpm']['skip_repository_install'] = false

default['php-fpm']['yum_url'] = 'http://rpms.famillecollet.com/enterprise/$releasever/remi/$basearch/'
default['php-fpm']['yum_mirrorlist'] = 'http://rpms.famillecollet.com/enterprise/$releasever/remi/mirror'

default['php-fpm']['dotdeb_repository']['uri'] = 'http://packages.dotdeb.org'
default['php-fpm']['dotdeb_repository']['key'] = 'http://www.dotdeb.org/dotdeb.gpg'
default['php-fpm']['dotdeb-php53_repository']['uri'] = 'http://php53.dotdeb.org'
