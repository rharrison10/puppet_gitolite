# gitolite puppet module

This module manages gitolite servers

## Classes

### gitolite

This class is used to install and setup a gitolite server.  At a minimum it
requires a public ssh key for the initial admin user and the username that 
admin will be identified by.

### gitolite::hooks

Verify the hooks directories are in place and installs some utility hooks
to make it possible to run multiple hook scripts for each hook stage.

### gitolite::hooks::post_receive_email

Installs the standard email hook from `contrib/hooks` provided with `git`.

### gitolite::params

The main variables for the module are set here.

### gitolite::package

This class simply installs the gitolite package for your OS.

### gitolite::package::user

Modify the user created by the gitolite package install.  This can be useful
if you need gitolite to be a member of specific groups for hook scripts to run
properly as an example.

### gitolite::refresh

This contains the `exec` resource required to refresh the gitolite
configuration when gitolite config files are changed or new hook scripts
are deployed.

## Defined Types

### gitolite::hooks::post_receive

Installs a post-receive hook script to be run on the repositories managed
by `gitolite`.

## Examples:

class test {
  file { '/srv/git' :
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }
   class { 'gitolite' :
    admin_key_source => 'puppet:///modules/test/username.pub',
    admin_user       => 'testuser',
    gitconfig_keys   => '.*',
    repo_base        => '/srv/git/repositories',
    repo_umask       => '0022',
    require          => File['/srv/git'],
  }
  
  gitolite::hooks::post_receive { 'example_post_receive' :
    source => 'puppet:///modules/test/example_post_receive.sh',
  }
}
