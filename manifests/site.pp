class { 'apt':
  always_apt_update => true,
}

apt::ppa { "ppa:brightbox/ruby-ng": }

class{'ruby':
    version             => '2.1.4',
    set_system_default  => true,
    latest_release      => true,
    require             => Apt::Ppa["ppa:brightbox/ruby-ng"],
}

class {'ruby::dev':
  require => Class["ruby"]
}

package { "ruby2.1-dev":
  ensure  => "installed",
  require => Class["ruby::dev"],
}

exec {'bundle install':
  command => '/bin/bash -c "bundle install --path ~/.gem"',
  user => "vagrant",
  cwd => "/srv/deja",
  require  => [Class["ruby::dev"], Package["ruby2.1-dev"]],
}

file { "/etc/init/deja.conf":
  ensure => "file",
  source => "/tmp/puppet-files/deja_upstart.conf",
  owner => "root",
  group => "root",
  mode => "644",
  notify => Service["deja"],
}

service { "deja":
  require => [File["/etc/init/deja.conf"],  Exec["bundle install"]],
  ensure   => "running",
  provider => "upstart", 
}

package { "nginx":
  ensure => "installed",
}

file { "/etc/nginx/sites-available/deja":
  ensure => "file",
  source => "/tmp/puppet-files/deja_nginx.conf",
  owner => "root",
  group => "root",
  mode => "644",
  require => Package["nginx"],
  notify => Service["nginx"],
}

file { "/etc/nginx/sites-enabled/default":
  ensure => "absent",
  require => Package["nginx"],
  notify => Service["nginx"],
}

file { "/etc/nginx/sites-enabled/deja":
  ensure => "link",
  target => "/etc/nginx/sites-available/deja",
  require => File["/etc/nginx/sites-available/deja"],
  notify => Service["nginx"],
}

service { "nginx":
  ensure  => "running",
  enable  => "true",
  require => Package["nginx"],
}

package { "phantomjs":
  ensure => "installed",
}

package { "openjdk-7-jdk":
  ensure => "installed",
}

exec { "download-logstash":
  command => "/usr/bin/wget -O /tmp/logstash-1.4.2.tar.gz https://download.elasticsearch.org/logstash/logstash/logstash-1.4.2.tar.gz",
  unless => "/usr/bin/test -d /usr/local/logstash-1.4.2",
}

exec { "install-logstash":
  command => "/bin/tar -xzf /tmp/logstash-1.4.2.tar.gz -C /usr/local",
  require => Exec["download-logstash"],
}

file {"/usr/local/logstash":
  ensure => "link",
  target => "/usr/local/logstash-1.4.2",
  require => Exec["install-logstash"],
}

package { "libzmq-dev":
  ensure => "installed",
}
