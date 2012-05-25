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
#   gid for the gitolite user's primary group
#
# [*groups*]
#   List of additional groups the gitolite user should be a member of.
#
# [*comment*]
#   Comment you wish to specify for the gitolite user.
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

   case $gid {
    undef: {
      $gid_real = $gitolite::params::group
      $group_requires = Package[$gitolite::params::package]
    }
    default: {
      $gid_real       = $gid
      $group_requires = undef
    }
  }

  Group[$gitolite::params::group] {
    gid       =>  $gid_real,
    requires  =>  $group_requires,
  }

  $comment_real = $comment ? {
    undef   =>  $gitolite::params::user_comment,
    default =>  $comment,
  }

  case $uid {
    undef: {
      $uid_real       = $gitolite::params::user_uid
      $user_requires  = [
        Package[$gitolite::params::package],
        Group[$gitolite::params::group],
      ]
    }
    default: {
      $uid_real       = $uid
      $user_requires  = Group[$gitolite::params::group]
    }
  }

  $groups_real = $groups

  User [$gitolite::params::user] {
    comment =>  $comment_real,
    uid     =>  $uid_real,
    groups  +>  $groups_real,
  }

  if $uid and $gid {
    $package_requires = [
      User [$gitolite::params::user],
      Group[$gitolite::params::group],
    ]
  } elsif $uid {
    $package_requires = User [$gitolite::params::user]
  } elsif $gid {
    $package_requires = Group[$gitolite::params::group]
  }

  Package[$gitolite::params::package] {
    require +> $package_requires,
  }
}
