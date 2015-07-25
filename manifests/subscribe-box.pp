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

# install mysql server
class { '::mysql::server':
  root_password           => 'root',
  remove_default_accounts => true,
  service_enabled         => true,
}

# create mysql database
mysql::db { 'clients':
  user     => 'shr-acct1',
  password => 'c0ff33b3an5',
  host     => 'localhost',
  grant    => ['ALL'],
}

# create mysql database
mysql::db { 'austbrokers_dev':
  user     => 'shr-acct2',
  password => 'c0ff33b3an5',
  host     => 'localhost',
  grant    => ['ALL'],
}

# grant permissions
mysql_grant { 'shr-acct1@localhost/*.*':
  ensure     => 'present',
  options    => ['GRANT'],
  privileges => ['ALL'],
  table      => '*.*',
  user       => 'shr-acct1@localhost',
}

# grant permissions
mysql_grant { 'shr-acct2@localhost/*.*':
  ensure     => 'present',
  options    => ['GRANT'],
  privileges => ['ALL'],
  table      => '*.*',
  user       => 'shr-acct2@localhost',
}