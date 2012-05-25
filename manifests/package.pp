# == Class: gitolite::package
#
# Install the gitolite package
#
# === Parameters
#
# None
#
# === Examples
#
#  include gitolite::package
#
# === Authors
#
# Russell Harrison <rharriso@redhat.com>
#
# === Copyright
#
# Copyright 2012 Russell Harrison, unless otherwise noted.
#
class gitolite::package {
  include gitolite::params

  package { $gitolite::params::package :
    ensure  =>  present,
    alias   =>  'gitolite',
  }

  group { $gitolite::params::group :
    ensure  =>  present,
    gid     =>  $gitolite::params::group_gid,
    require =>  Package[$gitolite::params::package],
  }

  user { $gitolite::params::user :
    ensure      =>  present,
    comment     =>  $gitolite::params::user_comment,
    uid         =>  $gitolite::params::user_uid,
    gid         =>  $gitolite::params::group,
    groups      =>  $gitolite::params::user_groups,
    membership  =>  minimum,
    home        =>  $gitolite::params::home,
    shell       =>  $gitolite::params::user_shell,
    require     =>  [
      Package[$gitolite::params::package],
      Group[$gitolite::params::group],
    ],
  }

}
