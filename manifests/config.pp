# == Class dariahshibboleth::config
#
# Class providing Shibboleth configuration
#
class dariahshibboleth::config (
  ) {

  include 'dariahshibboleth::metadata'

  if $dariahshibboleth::enable {

    $templateschooserstring = pick($dariahshibboleth::federation,'dariahidp')
    
    file { '/etc/shibboleth/attribute-map.xml':
      ensure  => present,
      owner   => root,
      group   => root,
      mode    => '0644',
      content => template('dariahshibboleth/etc/shibboleth/attribute-map.xml.erb'),
      require => Package['shibboleth'],
      notify  => Service['shibd'],
    }

    file { '/etc/shibboleth/attribute-policy.xml':
      ensure  => present,
      owner   => root,
      group   => root,
      mode    => '0644',
      content => template('dariahshibboleth/etc/shibboleth/attribute-policy.xml.erb'),
      require => Package['shibboleth'],
      notify  => Service['shibd'],
    }

    file { '/etc/shibboleth/shibboleth2.xml':
      ensure  => present,
      owner   => root,
      group   => root,
      mode    => '0644',
      content => template('dariahshibboleth/etc/shibboleth/shibboleth2.xml.erb'),
      require => Package['shibboleth'],
      notify  => Service['shibd'],
    }

    file { '/etc/shibboleth/attrChecker.html':
      ensure  => present,
      owner   => root,
      group   => root,
      mode    => '0644',
      content => template('dariahshibboleth/etc/shibboleth/attrChecker.html.erb'),
      require => Package['shibboleth'],
    }
    
    if $dariahshibboleth::cert != '' {
      file { '/etc/shibboleth/sp-cert.pem':
        ensure  => present,
        owner   => root,
        group   => root,
        mode    => '0644',
        source  => $dariahshibboleth::cert,
        require => Package['shibboleth'],
        notify  => Service['shibd'],
      }
    }

    if $dariahshibboleth::key != '' {
      file { '/etc/shibboleth/sp-key.pem':
        ensure  => present,
        owner   => '_shibd',
        group   => root,
        mode    => '0400',
        source  => $dariahshibboleth::key,
        require => Package['shibboleth'],
        notify  => Service['shibd'],
      }
    }

    if $dariahshibboleth::federation != '' {

      file { '/etc/shibboleth/dfn-aai.pem':
        ensure  => present,
        owner   => '_shibd',
        group   => root,
        mode    => '0644',
        source  => 'puppet:///modules/dariahshibboleth/etc/shibboleth/dfn-aai.pem',
        require => Package['shibboleth'],
        notify  => Service['shibd'],
      }
      staging::deploy { 'ds4b.tgz':
        source  => 'puppet:///modules/dariahshibboleth/opt/dariahshibboleth/ds4b.tgz',
        target  => '/var/www',
        creates => '/var/www/ds4b',
        require => Package['shibboleth'],
      }

    }

  }
}




