# == Define: module
#
# Enables python module.
#

include python3

define python3::pip() { 
  
  if ("${name}" == 'lxml') {
    include libxml2
    $package = [Class['libxml2']]
  } else {
    $package = []
  }
  
  exec { "installing pip package ${name}":
    command => "pip3 install ${name}",
    require => [Class['python3'], $package],
  }
}