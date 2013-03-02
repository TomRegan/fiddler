file { '/Users/tom/Development/code/puppet/fiddler/README.md':
  ensure => file,
  mode => 644,
  source => '/Users/tom/test.template',
}
