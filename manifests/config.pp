# This private class configures the shibboleth SP.
#
class dariahshibboleth::config inherits dariahshibboleth {

  file { '/etc/shibboleth/attribute-map.xml':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('dariahshibboleth/etc/shibboleth/attribute-map.xml.erb'),
  }

  file { '/etc/shibboleth/attribute-policy.xml':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('dariahshibboleth/etc/shibboleth/attribute-policy.xml.erb'),
  }

  file { '/etc/shibboleth/shibboleth2.xml':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('dariahshibboleth/etc/shibboleth/shibboleth2.xml.erb'),
  }

  file { '/etc/shibboleth/attrChecker.html':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('dariahshibboleth/etc/shibboleth/attrChecker.html.erb'),
  }

  unless $::dariahshibboleth::cert == undef {
    file { '/etc/shibboleth/sp-cert.pem':
      ensure => file,
      owner  => 'root',
      group  => 'root',
      mode   => '0644',
      source => $::dariahshibboleth::cert,
    }

    # parse the cert into variable for use by template below
    $_shibcertfilenameonly = regsubst($::dariahshibboleth::cert,'puppet:///modules/','')
    $_shibbolethcert = file($_shibcertfilenameonly)

    $shibd_metadata = $::dariahshibboleth::params::shibd_metadata

    file { '/opt/dariahshibboleth/sp-metadata.xml':
      ensure  => file,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => template('dariahshibboleth/opt/dariahshibboleth/sp-metadata.xml.erb'),
    }
  }

  unless $::dariahshibboleth::key == undef {
    file { '/etc/shibboleth/sp-key.pem':
      ensure => file,
      owner  => '_shibd',
      group  => 'root',
      mode   => '0400',
      source => $::dariahshibboleth::key,
    }
  }

  file { '/etc/shibboleth/dfn-aai.pem':
    ensure => file,
    owner  => '_shibd',
    group  => 'root',
    mode   => '0644',
    source => 'puppet:///modules/dariahshibboleth/etc/shibboleth/dfn-aai.pem',
  }

  file { '/etc/shibboleth/localLogout.html':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('dariahshibboleth/etc/shibboleth/localLogout.html.erb'),
  }

  file { '/etc/shibboleth/metadataError.html':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('dariahshibboleth/etc/shibboleth/metadataError.html.erb'),
  }

  file { '/etc/shibboleth/sessionError.html':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('dariahshibboleth/etc/shibboleth/sessionError.html.erb'),
  }

}


