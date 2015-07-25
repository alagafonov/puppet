# Class: git
#
# This class installs and configures git
#

class git {
  package { ['git']:
    ensure => present;
  }
}
