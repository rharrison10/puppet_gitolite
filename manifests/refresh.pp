# == Class: gitolite::refresh
#
# Refresh the gitolite configuration when any of the config files are updated
#
# === Parameters
#
# none
#
# === Variables
#
# none
#
# === Examples
#
#  include gitolite::refresh
#  file { 'configfile' :
#    ensure => present,
#    notify => Exec['gl-setup -q']
#  }
#
# === Authors
#
# Russell Harrison <rharriso@redhat.com>
#
# === Copyright
#
# Copyright 2012 Russell Harrison, unless otherwise noted.
#
class gitolite::refresh {
  Class['gitolite'] -> Class['gitolite::refresh']
  include gitolite::package
  include gitolite::params

  exec { 'gl-setup -q' :
    command     => 'gl-setup -q',
    refreshonly =>  true,
    cwd         =>  '/var/lib/gitolite',
    path        =>  [
      '/bin',
      '/usr/bin',
      '/usr/sbin',
      '/sbin',
    ],
    environment =>  "HOME=${gitolite::params::home}",
    user        =>  'gitolite',
    group       =>  'gitolite',
    logoutput   =>  true,
    require     => [
      File[$gitolite::params::gitoliterc_file],
      Exec['gl-setup'],
    ],
  }
}
