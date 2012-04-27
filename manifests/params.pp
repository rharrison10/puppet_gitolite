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

  $home = $::operatingsystem ? {
    /(CentOS|Fedora|RedHat)/  => '/var/lib/gitolite',
    default                   => '/var/lib/gitolite',
  }

  $admindir = "${home}/.gitolite"
  $common_hook_dir = "${admindir}/hooks/common"
  $gitoliterc_file = "${gitolite::params::home}/.gitolite.rc"

}
