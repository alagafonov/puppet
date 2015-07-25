# Class: libxml2
#
# This class installs and configures libxml
#

class libxml2 {
  package { ['libxml2-dev','libxslt1-dev']:
    ensure => present;
  }
}
