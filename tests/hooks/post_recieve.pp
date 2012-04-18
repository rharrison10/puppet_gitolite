gitolite::hooks::post_recieve { 'post-receive-email' :
  source  =>  'puppet:///modules/gitolite/post-receive-email.sh',
}

class { 'gitolite' :
    admin_key   =>  'puppet:///modules/gitolite/id_rsa_test.pub',
    admin_user  =>  'testuser',
}
