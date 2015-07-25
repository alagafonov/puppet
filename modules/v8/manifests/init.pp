# == Class: v8
#
# Compiles v8 library and 
#

include git
include gpp

class v8 (
  $v8Version = "4.5.97",
  $libPath = '/libraries',
) {
  
  $depotPath = "${libPath}/depot_tools"
  $v8Path = "${libPath}/v8"
  $tempArFile = "/tmp/_libv8_libplatform_ar_script"
  
  # add depot tools to exec parameters
  Exec {
    path => "${depotPath}:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
  }
  
  # get depot tools if not already exist
  exec { "getting depot_tools":
    command => "git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git ${depotPath}",
    require => Package['git'],
    onlyif  => "test ! -d ${depotPath}"
  } ->
  
  # fetch v8
  exec { "fetching v8":
    command => "fetch v8",
    cwd     => $libPath,
    onlyif  => "test ! -d ${$v8Path}",
    timeout => 7200
  } ->
  
  # fetch v8
  exec { "checkout v8 version ${v8Version}":
    command => "git checkout ${v8Version}",
    cwd     => $v8Path,
    timeout => 1800
  } ->
  
  # gclient sync
  exec { "gclient sync":
    command => "gclient sync",
    cwd     => $v8Path,
    timeout => 1800
  } ->
  
  # compile v8
  exec { "compile v8 version ${v8Version}":
    command => "make native library=shared -j8",
    cwd     => $v8Path,
    onlyif  => "test ! -d ${$v8Path}/out/native",
    timeout => 7200
  } ->
  
  # make sure we have lib and include folders
  exec { "create lib and include folders":
    command => "sudo mkdir -p /usr/lib /usr/include",
  } ->
  
  # copy compiled libraries to /usr/lib
  exec { "copy compiled libs":
    command => "cp ${$v8Path}/out/native/lib.target/lib*.so /usr/lib/",
  } ->
  
  # copy include headers to /usr/include
  exec { "copy include headers":
    command => "cp -R ${$v8Path}/include/* /usr/include",
  } ->
  
  # create temp archive script
  file { "create ${tempArFile}":
    path => $tempArFile,
    ensure => present,
    content => "create /usr/lib/libv8_libplatform.a\naddlib ${$v8Path}/out/native/obj.target/tools/gyp/libv8_libplatform.a\nsave\nend",
  } ->
  
  # create libv8_libplatform.a
  exec { "create libv8_libplatform.a":
    command => "ar -M < ${tempArFile}",
  } ->
  
  # remove temporary file
  exec { "delete ${tempArFile}":
    command => "rm ${tempArFile}",
  }
}
