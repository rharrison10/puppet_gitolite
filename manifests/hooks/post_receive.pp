# == Define: gitolite::hooks::post_receive
#
# Deploy a script to be run by the post-receive hook script on gitolite repos
#
# === Parameters
#
# Document parameters here
#
# [*source*]
#   The source location of your post-receive hook script
#
# [*template*]
#   A template or string providing the content of your post-receive
#   hook script
#
# === Examples
#
#  class test{
#    class { 'gitolite' :
#      admin_key_source => 'puppet:///modules/test/id_rsa_test.pub',
#      admin_user       => 'testuser',
#    }
#    gitolite::hooks::post_receive { 'test_script'
#      source  =>  'puppet:///modules/test/test_script',
#    }
#  }
#
# === Authors
#
# Russell Harrison <rharriso@redhat.com>
#
# === Copyright
#
# Copyright 2012 Russell Harrison, unless otherwise noted.
#
define gitolite::hooks::post_receive (
    $source = '',
    $template = ''
  ){

  include gitolite::package
  include gitolite::params
  include gitolite::hooks
  include gitolite::refresh

  $filename = "${gitolite::params::common_hook_dir}/post-receive.d/${name}"

  if $template and $source {
    fail('You cannot supply both template and source for gitolite::hooks::post_receive')
  } elsif $template == '' and $source == '' {
    fail('You must supply either a template or a source for gitolite::hooks::post_receive')
  }

  $script_source = $source ? {
    ''      =>  undef,
    default =>  $source,
  }

  $script_template = $template ? {
    ''      =>  undef,
    default =>  $template,
  }

  file { $filename :
    ensure  =>  file,
    content =>  $script_template,
    source  =>  $script_source,
    owner   =>  'gitolite',
    group   =>  'gitolite',
    mode    =>  '0755',
    require =>  Package['gitolite'],
    notify  =>  Exec['gl-setup -q'],
  }

}
