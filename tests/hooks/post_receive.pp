gitolite::hooks::post_receive { 'post-receive-email' :
  source  =>  'puppet:///modules/gitolite/post-receive-email.sh',
}

class { 'gitolite' :
  admin_key_source  =>  'puppet:///modules/gitolite/id_rsa_test.pub',
  admin_user        =>  'testuser',
}
