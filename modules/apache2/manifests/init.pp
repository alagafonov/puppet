# == Class: apache
#
# Installs packages for Apache2, enables modules, and sets config files.
#
class apache2 {
  package { ['apache2', 'apache2-mpm-prefork']:
    ensure => present;
  }

  service { 'apache2':
    ensure  => running,
    require => Package['apache2'];
  }
  
  file { "/etc/apache2/sites-enabled":
    ensure => 'directory',
    purge => true,
    force => true,
    recurse => true,
    require => Package['apache2'];
  }
  
  file { "/var/www":
    ensure => 'directory',
    purge => true,
    force => true,
    recurse => true,
    require => Package['apache2'];
  }

  apache2::module { ['rewrite', 'ssl']: }
  apache2::hosts { ['default.conf', 'default-ssl.conf']: }
  
  file {
    "/var/www/app":
      ensure => link,
      target => "/vagrant",
      require => Package['apache2'];
  }
}
