# Class: unzip
#
# This class installs and configures unzip
#

class unzip {
  package { ['unzip']:
    ensure => present;
  }
}
