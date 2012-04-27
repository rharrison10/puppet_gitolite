# == Class: gitolite::hooks::post_receive_email
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

  gitolite::hooks::post_receive { 'post-receive-email' :
    source  =>  'puppet:///modules/gitolite/post-receive-email.sh',
  }
}
