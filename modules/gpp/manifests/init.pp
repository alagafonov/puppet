# Class: g++
#
# This class installs and configures g++
#

class gpp {
  package { ['g++-multilib']:
    ensure => present;
  }
}
