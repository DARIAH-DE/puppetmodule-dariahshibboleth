# This private class configures the shibboleth SP.
#
# @param dfn_metadata The DFN metadata set to use.
# @param cert The shibboleth SP's key.
# @param edugain_enabled Enables the use of eduGain metafederation.
# @param federation_enabled Enables the use of federation metadata.
# @param hostname The hostname to use in building the SP metadata.
# @param idp_entityid The enityID of the IdP to use.
# @param key The shibboleth SP's key.
#
class dariahshibboleth::config (
  $hostname           = undef,
  $idp_entityid       = undef,
  $federation_enabled = undef,
  $edugain_enabled    = undef,
  $cert               = undef,
  $key                = undef,
  $dfn_metadata       = undef,
  $mail_contact       = undef,
) inherits dariahshibboleth::params {

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

    # parse the cert into variable for use by template below
    $_shibcertfilenameonly = regsubst($cert,'puppet:///modules/','')
    $_shibbolethcert = file($_shibcertfilenameonly)

    $shibd_metadata = $::dariahshibboleth::params::shibd_metadata

    file { '/opt/dariahshibboleth/sp-metadata.xml':
      ensure  => present,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => template('dariahshibboleth/opt/dariahshibboleth/sp-metadata.xml.erb'),
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

  file { '/etc/shibboleth/dfn-aai.pem':
    ensure => present,
    owner  => '_shibd',
    group  => 'root',
    mode   => '0644',
    source => 'puppet:///modules/dariahshibboleth/etc/shibboleth/dfn-aai.pem',
  }

}




