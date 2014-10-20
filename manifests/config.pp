# == Class dariahshibboleth::config
#
# Class providing Shibboleth configuration
#
class dariahshibboleth::config (
  ) {

  include 'dariahshibboleth::metadata'

  if $dariahshibboleth::enable {

    $templateschooserstring = pick($dariahshibboleth::federation,'dariahidp')
    
    $shibboleth2_xml_erb  = pick($dariahshibboleth::customshibboleth2xmltemplate,"dariahshibboleth/etc/shibboleth/shibboleth2.xml_${templateschooserstring}.erb")
    $attrChecker_html     = "puppet:///modules/dariahshibboleth/etc/shibboleth/attrChecker_${templateschooserstring}.html"
    $attribute_map_xml    = 'puppet:///modules/dariahshibboleth/etc/shibboleth/attribute-map.xml'
    $attribute_policy_xml = "puppet:///modules/dariahshibboleth/etc/shibboleth/attribute-policy_${templateschooserstring}.xml"

    file { '/etc/shibboleth/attribute-map.xml':
      ensure  => present,
      owner   => root,
      group   => root,
      mode    => '0644',
      source  => $attribute_map_xml,
      require => Package['shibboleth'],
      notify  => Service['shibd'],
    }

    file { '/etc/shibboleth/attribute-policy.xml':
      ensure  => present,
      owner   => root,
      group   => root,
      mode    => '0644',
      source  => $attribute_policy_xml,
      require => Package['shibboleth'],
      notify  => Service['shibd'],
    }

    file { '/etc/shibboleth/shibboleth2.xml':
      ensure  => present,
      owner   => root,
      group   => root,
      mode    => '0644',
      content => template($shibboleth2_xml_erb),
      require => Package['shibboleth'],
      notify  => Service['shibd'],
    }

    file { '/etc/shibboleth/attrChecker.html':
      ensure  => present,
      owner   => root,
      group   => root,
      mode    => '0644',
      source  => $attrChecker_html,
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

        source  => 'puppet:///modules/dariahshibboleth/opt/dariahcommon/ds4b.tgz',
        target  => '/var/www',
        creates => '/var/www/ds4b',
        require => Package['shibboleth'],
      }

    }

  }
}




