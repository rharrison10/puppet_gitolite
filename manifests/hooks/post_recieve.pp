define gitolite::hooks::post_recieve (
        $content = '',
        $source = ''
    ){

    include gitolite::package
    include gitolite::params
    include gitolite::hooks
    include gitolite::refresh

    $filename = "${gitolite::params::common_hook_dir}/post-receive.d/${name}"

    File {
        ensure  =>  file,
        owner   =>  'gitolite',
        group   =>  'gitolite',
        mode    =>  '0755',
        require =>  Package['gitolite'],
        notify  =>  Exec['gl-setup -q'],
    }

    if $source == '' {
        file { $filename :
            content  =>  $content,
        }
    } else {
        file { $filename :
            source  =>  $source,
        }
    }

}
