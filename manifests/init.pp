# This class provides the dariahshibboleth module.
# It installs and configures the SP.
#
# @param dfn_metadata The DFN metadata set to use.
# @param cert The shibboleth SP's key.
# @param discoveryurl
# @param edugain_enabled Enables the use of eduGain metafederation.
# @param federation_enabled Enables the use of federation metadata.
# @param handlerurl_prefix
# @param hostname The hostname to use in building the SP metadata.
# @param idp_entityid The enityID of the IdP to use.
# @param idp_loginurl
# @param key The shibboleth SP's key.
#
class dariahshibboleth (
    $hostname           = $::fqdn,
    $idp_entityid       = $dariahshibboleth::params::idp_entityid,
    $idp_loginurl       = $dariahshibboleth::params::idp_loginurl,
    $handlerurl_prefix  = '',
    $discoveryurl       = "https://${::fqdn}/ds",
    $key                = '',
    $cert               = '',
    $dfn_metadata       = $dariahshibboleth::params::dfn_metadata,
    $federation_enabled = $dariahshibboleth::params::federation_enabled,
    $edugain_enabled    = $dariahshibboleth::params::edugain_enabled,
    $fakeshibdata       = $dariahshibboleth::params::fakeshibdata,
  ) inherits dariahshibboleth::params {


  class { 'dariahshibboleth::install':
  }->
  class { 'dariahshibboleth::config':
    hostname           => $hostname,
    idp_entityid       => $idp_entityid,
    cert               => $cert,
    key                => $key,
    dfn_metadata       => $dfn_metadata,
    federation_enabled => $federation_enabled,
    edugain_enabled    => $edugain_enabled,
  }~>
  class { 'dariahshibboleth::service':
  }

}

