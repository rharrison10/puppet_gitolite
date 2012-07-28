# == Class: gitolite::hooks::post_receive
#
# post-receive hook and the hooklet directory it uses.
#
# === Parameters
#
# None
#
# === Examples
#
#  include gitolite::post_receive
#
# === Authors
#
# Russell Harrison <rharriso@redhat.com>
#
# === Copyright
#
# Copyright 2012 Russell Harrison, unless otherwise noted.
#
class gitolite::hooks::post_receive {
  include gitolite::hooks
  include gitolite::package
  include gitolite::params
  include gitolite::refresh

  file { "${gitolite::params::common_hook_dir}/post-receive.d" :
    ensure  =>  directory,
    owner   =>  'gitolite',
    group   =>  'gitolite',
    mode    =>  '0775',
    require =>  Package['gitolite'],
  }

  $receive_stage = 'post'

  file { "${gitolite::params::common_hook_dir}/post-receive" :
    ensure  =>  file,
    content =>  template('gitolite/hooks/receive.sh.erb'),
    owner   =>  'gitolite',
    group   =>  'gitolite',
    mode    =>  '0755',
    require =>  [
      Package['gitolite'],
      File["${gitolite::params::common_hook_dir}/post-receive.d"],
    ],
    notify  =>  Exec['gl-setup -q'],
  }
}
