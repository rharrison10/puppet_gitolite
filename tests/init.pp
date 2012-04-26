class { 'gitolite' :
  admin_key_source =>  'puppet:///modules/gitolite/id_rsa_test.pub',
  admin_user       =>  'testuser',
}
