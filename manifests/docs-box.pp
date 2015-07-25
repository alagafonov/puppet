# create a new run stage to ensure certain modules are included first
stage { 'prereq':
  before => Stage['main']
}

# add the baseconfig module to the new 'pre' run stage
class { 'baseconfig':
  stage => 'prereq'
}

# set defaults for file ownership/permissions
File {
  owner => 'root',
  group => 'root',
  mode  => '0644',
}

# exec parameters
Exec {
  path => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
}

include baseconfig, unzip, git, apache2, php5

# install postgres
class { 'postgresql::globals':
  manage_package_repo => true,
  version             => '9.3',
}->
class { 'postgresql::server':
  listen_addresses    => '*',
  postgres_password   => 'postgres',
}

# install contrib modules
class { 'postgresql::server::contrib':
  package_ensure => 'present',
}

# install postgis modules
class { 'postgresql::server::postgis':
  package_ensure => 'present',
}

# install postgres server
postgresql::server::db { 'docs':
  user     => 'docs',
  password => postgresql_password('docs', 'devDrs$$'),
  require  => Class['postgresql::server'],
}

# install mysql server
class { '::mysql::server':
  root_password           => 'root',
  remove_default_accounts => true,
  service_enabled         => true,
}

# create mysql database
mysql::db { 'docs_wp':
  user     => 'docs',
  password => 'devDrs$$',
  host     => 'localhost',
  grant    => ['ALL'],
}

# install python
class { 'python3':
  version => 3.4,
}

python3::module { ['psycopg2']: }
python3::pip { ['lxml','requests']: }