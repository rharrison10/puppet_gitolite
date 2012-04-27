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
}
