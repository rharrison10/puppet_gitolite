class { 'gitolite::package::user' :
  groups  =>  ['users', 'wheel'],
}
