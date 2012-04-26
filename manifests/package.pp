class gitolite::package {
  include gitolite::params

  package { $gitolite::params::package :
    ensure  =>  present,
    alias   =>  'gitolite',
  }
}
