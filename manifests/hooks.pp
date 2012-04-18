class gitolite::hooks {
    include gitolite::package
    include gitolite::params
    include gitolite::refresh

    $hook_dirs = [
        "${gitolite::params::admindir}/hooks",
        $gitolite::params::common_hook_dir,
        "${gitolite::params::common_hook_dir}/post-receive.d",
    ]

    file { $hook_dirs :
        ensure  =>  directory,
        owner   =>  'gitolite',
        group   =>  'gitolite',
        mode    =>  '0775',
        require =>  Package['gitolite'],
    }

    file { "${gitolite::params::common_hook_dir}/post-receive" :
        ensure  =>  file,
        source  =>  'puppet:///modules/gitolite/post-receive.sh',
        owner   =>  'gitolite',
        group   =>  'gitolite',
        mode    =>  '0755',
        require =>  Package['gitolite'],
        notify  =>  Exec['gl-setup -q'],
    }
}
