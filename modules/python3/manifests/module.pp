# == Define: module
#
# Enables python module.
#

include python3

define python3::module() {  
  package { ["python3-${name}"]:
    ensure => present,
    require => Class['python3'],
  }
}
