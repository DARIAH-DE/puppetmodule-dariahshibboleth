# == Class dariahshibboleth::config
#
# Class providing Shibboleth configuration
#
class dariahshibboleth::config (
  $federation = undef,
  $cert       = undef,
  $key        = undef,
  ) inherits dariahshibboleth::params {

  include 'dariahshibboleth::metadata'

  file { '/etc/shibboleth/attribute-map.xml':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('dariahshibboleth/etc/shibboleth/attribute-map.xml.erb'),
  }

  file { '/etc/shibboleth/attribute-policy.xml':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('dariahshibboleth/etc/shibboleth/attribute-policy.xml.erb'),
  }

  file { '/etc/shibboleth/shibboleth2.xml':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('dariahshibboleth/etc/shibboleth/shibboleth2.xml.erb'),
  }

  file { '/etc/shibboleth/attrChecker.html':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('dariahshibboleth/etc/shibboleth/attrChecker.html.erb'),
  }

  if $cert {
    file { '/etc/shibboleth/sp-cert.pem':
      ensure => present,
      owner  => 'root',
      group  => 'root',
      mode   => '0644',
      source => $dariahshibboleth::cert,
    }
  }

  if $key {
    file { '/etc/shibboleth/sp-key.pem':
      ensure => present,
      owner  => '_shibd',
      group  => 'root',
      mode   => '0400',
      source => $dariahshibboleth::key,
    }
  }

  if $federation {

    file { '/etc/shibboleth/dfn-aai.pem':
      ensure => present,
      owner  => '_shibd',
      group  => 'root',
      mode   => '0644',
      source => 'puppet:///modules/dariahshibboleth/etc/shibboleth/dfn-aai.pem',
    }
    staging::deploy { 'ds4b.tgz':
      source  => 'puppet:///modules/dariahshibboleth/opt/dariahshibboleth/ds4b.tgz',
      target  => '/var/www',
      creates => '/var/www/ds4b',
    }

  }

}




