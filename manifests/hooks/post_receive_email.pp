# == Class: gitolite::hooks::post_receive_email_hooklet
#
# Deploy the post-receive hook script to email push notifications provided with
# git at contrib/hooks/post-receive-email
#
# === Parameters
#
# None
#
# === Variables
#
# None
#
# === Examples
#
#  include gitolite::hooks::post_receive_email
#  class { 'gitolite' :
#    admin_key_source  =>  'puppet:///modules/gitolite/id_rsa_test.pub',
#    admin_user        =>  'testuser',
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
class gitolite::hooks::post_receive_email {

  file { "${gitolite::params::common_hook_dir}/post-receive.d/email":
    ensure  => link,
    target  => '/usr/share/git-core/contrib/hooks/post-receive-email',
    owner   => 'gitolite',
    group   => 'gitolite',
    mode    => '0755',
    require => [
      Package['gitolite'],
      File["${gitolite::params::common_hook_dir}/post-receive.d"],
    ],
  }
}
