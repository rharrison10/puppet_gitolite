include gitolite::hooks::post_recieve_email

class { 'gitolite' :
    admin_key   =>  'puppet:///modules/gitolite/id_rsa_test.pub',
    admin_user  =>  'testuser',
}