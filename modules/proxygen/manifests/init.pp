# == Class: proxygen
#
# Compiles proxygen library and its dependencies
#

include git, gpp, unzip

class proxygen (
  $libPath = '/libraries',
  $version = 'v0.28.0'
) {
  
  $proxygenPath = "${libPath}/proxygen"
  
  # get depot tools if not already exist
  exec { "get proxygen":
    command => "git clone https://github.com/facebook/proxygen.git ${proxygenPath}",
    require => Package['git'],
    onlyif  => "test ! -d ${proxygenPath}"
  } ->
  
  # get specific version of proxygen
  exec { "get proxygen version ${version}":
    command => "git checkout tags/${version}",
    cwd     => $proxygenPath,
  } ->
  
  # build proxygen deps
  exec { "build proxygen deps":
    command => "${proxygenPath}/proxygen/deps.sh",
    cwd     => $proxygenPath,
    timeout => 7200,
  } ->
  
  # install proxygen
  exec { "install proxygen":
    command => "${proxygenPath}/proxygen/reinstall.sh",
    cwd     => $proxygenPath,
    timeout => 3600,
  } 
}
