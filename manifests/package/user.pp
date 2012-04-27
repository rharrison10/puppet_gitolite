# == Class: gitolite::package::user
#
# Modify the user gitolite runs as.
#
# *WARNING* do not change this user lightly.  You can seriously break gitolite
# doing so.
#
# === Parameters
#
# [*uid*]
#   specific uid to user for the gitolite user
#
# [*gid*]
#   Primary group for the gitolite user
#
# [*groups*]
#   List of sdditional groups the gitolite user should be a member of.
#
# === Examples
#
#  include gitolite::package
#  class { 'gitolite::package::user' :
#    groups   => [ 'jenkens', 'testing' ],
#    require  => Group['jenkens','testing'],
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
class gitolite::package::user (
    $comment = undef,
    $uid = undef,
    $gid = undef,
    $groups = undef
  ) inherits gitolite::package {

  include gitolite::params

  $comment_real = $comment ? {
    undef   =>  $gitolite::params::user_comment,
    default =>  $comment,
  }

  $uid_real = $uid ? {
    undef   =>  $gitolite::params::user_uid,
    default =>  $uid,
  }

  $gid_real = $gid ? {
    undef   =>  $gitolite::params::group,
    default =>  $gid,
  }

  $groups_real = $groups ? {
    undef   =>  '',
    default =>  $groups,
  }

  User [$gitolite::params::user] {
    comment =>  $comment_real,
    uid     =>  $uid_real,
    gid     =>  $gid_real,
    groups  =>  $groups_real,
    home    =>  $gitolite::params::home,
    shell   =>  $gitolite::params::user_shell,
    system  =>  true,
  }
}
