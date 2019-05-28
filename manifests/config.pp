# This private class configures the shibboleth SP.
#
# @param session_handler_show_attribute_values Boolean to enable debug option showing the attributes' values at the Session handler.
#
class dariahshibboleth::config (
  $session_handler_show_attribute_values = false
) inherits dariahshibboleth {

  if ($::dariahshibboleth::standby_cert != undef) and ($::dariahshibboleth::standby_key != undef) {
    $_cert_rollover = true
    # parse the cert into variable for use by template below
    $_shibstandbycertfilenameonly = regsubst($::dariahshibboleth::standby_cert,'puppet:///modules/','')
    $_shibbolethstandbycert = file($_shibstandbycertfilenameonly)

  } else {
    $_cert_rollover = false
  }

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

  if ($::dariahshibboleth::tou_sp_tou_group != undef) and ($::dariahshibboleth::tou_enforced) {
    $_tou_initial_group = "%3Binitialgroup%3D${$::dariahshibboleth::tou_sp_tou_group}"
  } else {
    $_tou_initial_group = undef
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

  if $::dariahshibboleth::standby_cert != undef {
    file { '/etc/shibboleth/sp-standby-cert.pem':
      ensure => file,
      owner  => 'root',
      group  => 'root',
      mode   => '0644',
      source => $::dariahshibboleth::standby_cert,
    }
  } else {
    file { '/etc/shibboleth/sp-standby-cert.pem':
      ensure => absent,
    }
  }

  if $::dariahshibboleth::standby_key != undef {
    file { '/etc/shibboleth/sp-standby-key.pem':
      ensure => file,
      owner  => '_shibd',
      group  => 'root',
      mode   => '0400',
      source => $::dariahshibboleth::standby_key,
    }
  } else {
    file { '/etc/shibboleth/sp-standby-key.pem':
      ensure => absent,
    }
  }

  file { '/etc/shibboleth/dfn-aai.g2.pem':
    ensure => file,
    owner  => '_shibd',
    group  => 'root',
    mode   => '0644',
    source => 'puppet:///modules/dariahshibboleth/etc/shibboleth/dfn-aai.g2.pem',
  }

  file { '/etc/shibboleth/dariah-proxy-idp.xml':
    ensure => file,
    owner  => '_shibd',
    group  => 'root',
    mode   => '0644',
    source => 'puppet:///modules/dariahshibboleth/etc/shibboleth/dariah-proxy-idp.xml',
  }

  file { '/etc/shibboleth/dariah-proxy-idp-integration.xml':
    ensure => file,
    owner  => '_shibd',
    group  => 'root',
    mode   => '0644',
    source => 'puppet:///modules/dariahshibboleth/etc/shibboleth/dariah-proxy-idp-integration.xml',
  }

  if ($::dariahshibboleth::custom_metadata_url != undef) and ($::dariahshibboleth::custom_metadata_signature_cert != undef) {
    $_with_custom_metadata_enabled = true
    file { '/etc/shibboleth/custom_metadata_signature.pem':
      ensure => file,
      owner  => '_shibd',
      group  => 'root',
      mode   => '0644',
      source => $::dariahshibboleth::custom_metadata_signature_cert,
    }
  } else {
    $_with_custom_metadata_enabled = false
    file { '/etc/shibboleth/custom_metadata_signature.pem':
      ensure => absent,
    }

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

  file { '/etc/shibboleth/shibboleth2.xml':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('dariahshibboleth/etc/shibboleth/shibboleth2.xml.erb'),
  }

}


