class gitolite::hooks::post_receive_email {

    gitolite::hooks::post_receive { 'post-receive-email' :
        source  =>  'puppet:///modules/gitolite/post-receive-email.sh',
    }
}
