# == Class: php
#
# Installs PHP5 and necessary modules. Sets config files.
#
class php5 {
  package { ['php5',
             'php5-cli',
             'libapache2-mod-php5',
             'php-apc',
             'php5-curl',
             'php5-dev',
             'php5-gd',
             'php5-imagick',
             'php5-mcrypt',
             'php5-memcache',
             'php5-mysql',
             'php5-pspell',
             'php5-sqlite',
             'php5-tidy',
             'php5-xdebug',
             'php5-xmlrpc',
             'php5-xsl',
			 'php5-imap',
			 'php-pear',
			 'php5-pgsql']:
    ensure => present;
  }
  
  file {
    '/etc/php5/apache2':
      ensure => directory,
      before => File ['/etc/php5/apache2/php.ini'];

    '/etc/php5/apache2/php.ini':
      source  => 'puppet:///modules/php5/php.ini',
      require => Package['php5', 'apache2'],
      notify => Service['apache2'];
  }
}
