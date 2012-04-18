class gitolite::params {
    $package = $::operatingsystem ? {
        /(CentOS|Fedora|RedHat)/    => 'gitolite',
        default                     => 'gitolite',
    }

    $home = $::operatingsystem ? {
        /(CentOS|Fedora|RedHat)/    => '/var/lib/gitolite',
        default                     => '/var/lib/gitolite',
    }

    $admindir = "${home}/.gitolite"
    $common_hook_dir = "${admindir}/hooks/common"
    $gitoliterc_file = "${gitolite::params::home}/.gitolite.rc"

}
