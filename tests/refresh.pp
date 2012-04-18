include gitolite::refresh
class { 'gitolite' :
    admin_key   =>  'puppet:///modules/gitolite/id_rsa_test.pub',
    admin_user  =>  'testuser',
}
