# == Class: gitolite::params
#
# Define variables used in the gitolite module
#
# === Parameters
#
# None
#
# === Variables
#
# [*::operatingsystem*]
#   Fact provided by facter giving a string describing the operating
#   system running on the node.
#
# === Examples
#
#  include gitolite::params
#
# === Authors
#
# Russell Harrison <rharriso@redhat.com>
#
# === Copyright
#
# Copyright 2012 Russell Harrison, unless otherwise noted.
#
class gitolite::params {

  $package = $::operatingsystem ? {
    /(CentOS|Fedora|RedHat)/  => 'gitolite',
    default                   => 'gitolite',
  }

  $user = $::operatingsystem ? {
    /(CentOS|Fedora|RedHat)/  => 'gitolite',
    default                   => 'gitolite',
  }

  $user_comment = $::operatingsystem ? {
    /(CentOS|Fedora|RedHat)/  => 'git repository hosting',
    default                   => 'git repository hosting',
  }

  $user_uid = $::operatingsystem ? {
    /(CentOS|Fedora|RedHat)/  => undef,
    default                   => undef,
  }

  $user_groups = $::operatingsystem ? {
    /(CentOS|Fedora|RedHat)/  => [],
    default                   => [],
  }

  $user_shell = $::operatingsystem ? {
    /(CentOS|Fedora|RedHat)/  => '/bin/sh',
    default                   => '/bin/sh',
  }

  $home = $::operatingsystem ? {
    /(CentOS|Fedora|RedHat)/  => '/var/lib/gitolite',
    default                   => '/var/lib/gitolite',
  }

  $group = $::operatingsystem ? {
    /(CentOS|Fedora|RedHat)/  => 'gitolite',
    default                   => 'gitolite',
  }

  $group_gid = $::operatingsystem ? {
    /(CentOS|Fedora|RedHat)/  => undef,
    default                   => undef,
  }

  $admindir = "${home}/.gitolite"
  $common_hook_dir = "${admindir}/hooks/common"
  $gitoliterc_file = "${gitolite::params::home}/.gitolite.rc"

}
