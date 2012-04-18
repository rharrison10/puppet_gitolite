class gitolite::hooks::post_recieve_email {

    gitolite::hooks::post_recieve { 'post-receive-email' :
        source  =>  'puppet:///modules/gitolite/post-receive-email.sh',
    }
}
