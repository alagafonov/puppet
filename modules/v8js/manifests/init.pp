# == Class: v8
#
# Compiles v8 library and 
#

include git
include gpp
include v8
include php5

class v8js (
  $libPath = '/libraries',
) {
  
  $v8jsPath = "${libPath}/v8js"
  
  # add depot tools to exec parameters
  Exec {
    path => "${depotPath}:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
  }
  
  # get v8js if not already exist
  exec { "getting v8js":
    command => "git clone https://github.com/preillyme/v8js.git {v8jsPath}",
    require => Package['git'],
    onlyif  => "test ! -d ${v8jsPath}"
  } ->
  
  # phpize v8js
  exec { "phpize v8js":
    command => "phpize",
    cwd     => $v8jsPath
  } ->
  
  # compile v8js
  exec { "configure v8js":
    command => "./configure",
    cwd     => $v8jsPath
  } ->
  
  # make v8js
  exec { "make v8js":
    command => "make",
    cwd     => $v8jsPath
  } ->
  
  # make install v8js
  exec { "make install v8js":
    command => "make install",
    cwd     => $v8jsPath
  }
}
