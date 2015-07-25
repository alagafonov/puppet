# == Define: module
#
# Enables an Apache module.
#
define apache2::module() {
  exec { "/usr/sbin/a2enmod $name" :
    unless => "/bin/readlink -e /etc/apache2/mods-enabled/${name}.load",
    require => Package['apache2'],
    notify => Service['apache2']
  }
}
