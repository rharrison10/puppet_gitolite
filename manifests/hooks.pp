# == Class: gitolite::hooks
#
# Verify the hooks directories are in place and installs some utility hooks
# to make it possible to run multiple hook scripts for each hook stage
#
# === Parameters
#
# None
#
# === Examples
#
#  class test {
#    include gitolite::hooks
#    class { 'gitolite' :
#      admin_key_source => 'puppet:///modules/test/id_rsa_test.pub',
#      admin_user       => 'testuser',
#    }
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
class gitolite::hooks {
  include gitolite::package
  include gitolite::params
  include gitolite::refresh

  $hook_dirs = [
    "${gitolite::params::admindir}/hooks",
    $gitolite::params::common_hook_dir,
    "${gitolite::params::common_hook_dir}/post-receive.d",
    "${gitolite::params::home}/tmp",
  ]

  file { $hook_dirs :
    ensure  =>  directory,
    owner   =>  'gitolite',
    group   =>  'gitolite',
    mode    =>  '0775',
    require =>  Package['gitolite'],
  }

  file { "${gitolite::params::common_hook_dir}/post-receive" :
    ensure  =>  file,
    source  =>  'puppet:///modules/gitolite/post-receive.sh',
    owner   =>  'gitolite',
    group   =>  'gitolite',
    mode    =>  '0755',
    require =>  Package['gitolite'],
    notify  =>  Exec['gl-setup -q'],
  }
}
