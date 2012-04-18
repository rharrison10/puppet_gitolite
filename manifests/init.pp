# Class: gitolite
#
# This module manages gitolite
#
# Parameters:
#
#  admin_key : The public key of the lead gitolite administrator
#       used in intial setup
#
#  admin_user : The username of the lead gitolite admin
#
#  gitoliterc_content   : Template or string providing the content
#       for .gitolite.rc
#
#  gitoliterc_source : Location of the .gitolite.rc source file
#
#  repo_base : Directory where gitolite repositories will be
#       created / managed.
#       NOTE parent directories of this directory are managed outside
#       of this module and so remember to call this class with
#       require => File['parentdir'] so it is present before this
#       module creates the repo_base
#
#  repo_umask : The umask gitolite will use when performing operations
#       on the repositories it manages
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
# class gitolitetest {
#  file { '/srv/git' :
#    ensure => directory,
#    owner  => 'root',
#    group  => 'root',
#    mode   => '0755',
#  }
#
# class { 'gitolite' :
#    admin_key      => 'puppet:///modules/gitolitetest/username.pub',
#    admin_user     => 'username',
#    gitconfig_keys => '.*',
#    repo_base      => '/srv/git/repositories',
#    repo_umask     => '0022',
#    require        => File['/srv/git'],
#  }
# }
#
# [Remember: No empty lines between comments and class definition]
class gitolite (
        $admin_key,
        $admin_user,
        $gitconfig_keys = '',
        $gitoliterc_content = template('gitolite/gitolite.rc.erb'),
        $gitoliterc_source = '',
        $repo_base = 'repositories',
        $repo_umask = '0077'
    ){

    include gitolite::package
    include gitolite::params
    include gitolite::refresh

    $repo_base_dir = $repo_base ? {
        'repositories'  =>  "${gitolite::params::home}/repositories",
        default         =>  $repo_base
    }

    $admin_key_file = "${gitolite::params::home}/.ssh/${admin_user}.pub"

    file { $admin_key_file :
        ensure  => file,
        source  => $admin_key,
        owner   =>  'gitolite',
        group   =>  'gitolite',
        mode    =>  '0644',
        require =>  Package['gitolite'],
    }

    file { $repo_base_dir :
        ensure  => directory,
        owner   => 'gitolite',
        group   => 'gitolite',
        mode    => '0755',
        require => Package['gitolite'],
    }

    if $gitolite::gitoliterc_source == '' {
        file { $gitolite::params::gitoliterc_file :
            ensure  =>  file,
            content =>  $gitoliterc_content,
            owner   => 'gitolite',
            group   => 'gitolite',
            mode    => '0644',
            require =>  [
                Package['gitolite'],
                File[$repo_base_dir],
            ],
            notify  =>  Exec['gl-setup -q'],
        }
    } else {
        file { $gitolite::params::gitoliterc_file :
            ensure  =>  file,
            source  =>  $gitoliterc_source,
            owner   => 'gitolite',
            group   => 'gitolite',
            mode    => '0644',
            require =>  [
                Package['gitolite'],
                File[$repo_base_dir],
            ],
            notify  =>  Exec['gl-setup -q'],
        }
    }

    file { $gitolite::params::admindir :
        ensure  =>  directory,
        owner   =>  'gitolite',
        group   =>  'gitolite',
        mode    =>  '0700',
        require =>  Package['gitolite'],
    }

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
