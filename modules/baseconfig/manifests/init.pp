# == Class: baseconfig
#
# Performs initial configuration tasks for all Vagrant boxes.
#
class baseconfig (
  $libPath = '/libraries',
) {
#  exec { 'apt-get update':
#    command => '/usr/bin/apt-get update';
#  }

#  file {
#    '/home/ubuntu/.bashrc':
#      owner => 'ubuntu',
#      group => 'ubuntu',
#      mode  => '0644',
#      source => 'puppet:///modules/baseconfig/bashrc';
#  }

# create a directory      
  file { $libPath:
    ensure => "directory",
  }
}
