# Class: python
#
# This class installs and configures git
#

class python3 (
  $version = 3.4,
) {
  
  $package = "python$version"
  
  package { [$package]:
    ensure => present;
  }
  
  package { ['python3-dev']:
    ensure => present,
    require => Package[$package],
  }
  
  package { ['python3-pip']:
    ensure => present,
    require => Package[$package],
  }
}
