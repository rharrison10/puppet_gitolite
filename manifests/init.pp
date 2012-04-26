# == Class: gitolite
#
# This module manages gitolite servers
#
# === Parameters:
#
# [*admin_user*]
#   The username of the lead gitolite admin
#
# [*admin_key_source*]
#   Source location of the public key of the lead gitolite
#   administrator used in intial setup
#
# [*admin_key_template*]
#   Template providing the content of the public key for the lead
#   gitolite administrator used in intial setup
#
# [*gl_wildrepos*]
#   The value of GL_WILDREPOS in .gitoliterc.
#   http://sitaramc.github.com/gitolite/g2/wild.html
#
# [*gl_gitconfig_keys*]
#   The value of GL_GITCONFIG_KEYS in .gitoliterc.
#
# [*repo_base*]
#   Directory where gitolite repositories will be created / managed.
#   *NOTE* parent directories of this directory will need to be managed
#   outside of this module so remember to call this class with
#   +require => File['parentdir'],+ so it is present before this
#   module creates the +repo_base+ directory under its parrents
#
# [*repo_umask*]
#   The umask gitolite will use when performing operations on the
#   repositories it manages
#
# [*gitoliterc_content*]
#   String providing the content for .gitolite.rc.
#   *WARNING* Only use this if you really know what you're doing.
#
# [*gitoliterc_source*]
#   Location of the .gitolite.rc source file
#   *WARNING* Only use this if you really know what you're doing.
#
# === Examples:
#
#  class gitolitetest {
#    file { '/srv/git' :
#      ensure => directory,
#      owner  => 'root',
#      group  => 'root',
#      mode   => '0755',
#    }
#
#    class { 'gitolite' :
#      admin_key_source => 'puppet:///modules/gitolitetest/username.pub',
#      admin_user       => 'username',
#      gitconfig_keys   => '.*',
#      repo_base        => '/srv/git/repositories',
#      repo_umask       => '0022',
#      require          => File['/srv/git'],
#    }
#  }
#
class gitolite (
    $admin_user,
    $admin_key_source = '',
    $admin_key_template = '',
    $gl_wildrepos = '0',
    $gl_gitconfig_keys = '',
    $repo_base = 'repositories',
    $repo_umask = '0077',
    $gitoliterc_template = '',
    $gitoliterc_source = ''
  ){

  include gitolite::package
  include gitolite::params
  include gitolite::refresh

# Put the public key in place for the default admin for the gitolite server

  $admin_key_file = "${gitolite::params::home}/.ssh/${admin_user}.pub"

  # Fail gracefully if user doesn't supply an admin_key or tries to supply
  # both source and template for the admin_key
  if $admin_key_template and $admin_key_source {
    fail('You cannot supply both template and source for the admin_key')
  } elsif $admin_key_template == '' and $admin_key_source =='' {
    fail('You must supply either a source or template for the admin_key')
  } elsif $admin_key_template != '' {
    $admin_key_template_real = $admin_key_template
    $admin_key_source_real = undef
  } elsif $admin_key_source != '' {
    $admin_key_template_real = undef
    $admin_key_source_real = $admin_key_source
  }

  file { $admin_key_file :
    ensure  =>  file,
    content =>  $admin_key_template_real,
    source  =>  $admin_key_source_real,
    owner   =>  'gitolite',
    group   =>  'gitolite',
    mode    =>  '0644',
    require =>  Package['gitolite'],
  }

  $repo_base_dir = $repo_base ? {
    'repositories'  =>  "${gitolite::params::home}/repositories",
    default         =>  $repo_base
  }

# Make sure the repository dir exists
  file { $repo_base_dir :
    ensure  => directory,
    owner   => 'gitolite',
    group   => 'gitolite',
    mode    => '0755',
    require => Package['gitolite'],
  }

  if $gitoliterc_source and $gitoliterc_template {
    fail('You cannot supply both template and source for the .gitoliterc file')
  } elsif $gitoliterc_source == '' and $gitoliterc_template == '' {
    $gitoliterc_template_real = template('gitolite/gitolite.rc.erb')
  } elsif $gitoliterc_source != '' {
    $gitoliterc_source_real = $gitoliterc_source
  } elsif $gitoliterc_template != '' {
    $gitoliterc_template_real = $gitoliterc_template
  }

  file { $gitolite::params::gitoliterc_file :
    ensure  =>  file,
    content =>  $gitoliterc_template_real,
    source  =>  $gitoliterc_source_real,
    owner   => 'gitolite',
    group   => 'gitolite',
    mode    => '0644',
    require =>  [
        Package['gitolite'],
        File[$repo_base_dir],
    ],
    notify  =>  Exec['gl-setup -q'],
  }

  file { $gitolite::params::admindir :
    ensure  =>  directory,
    owner   =>  'gitolite',
    group   =>  'gitolite',
    mode    =>  '0700',
    require =>  Package['gitolite'],
  }

# Run the intitial configuration of gitolite
  exec { 'gl-setup' :
    command     => "gl-setup -q ${admin_key_file}",
    creates     => "${gitolite::params::admindir}/conf/gitolite.conf",
    cwd         =>  '/var/lib/gitolite',
    path        =>  [
      '/bin',
      '/usr/bin',
      '/usr/sbin',
      '/sbin',
    ],
    environment =>  "HOME=${gitolite::params::home}",
    user        =>  'gitolite',
    group       =>  'gitolite',
    logoutput   =>  true,
    require     => [
      Package['gitolite'],
      File[
        $repo_base_dir,
        $gitolite::params::gitoliterc_file,
        $admin_key_file
      ],
    ],
  }

}
