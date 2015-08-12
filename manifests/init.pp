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
# @param idp_loginurl LoginURL of IdP for AttrChecker in federation.
# @param key The shibboleth SP's key.
# @param mail_contact The contact mail address for metadata.
# @param remote_user_pref_list The preference list for REMOTE_USER.
#
class dariahshibboleth (
    $hostname              = $::fqdn,
    $idp_entityid          = $dariahshibboleth::params::idp_entityid,
    $idp_loginurl          = $dariahshibboleth::params::idp_loginurl,
    $handlerurl_prefix     = '',
    $discoveryurl          = "https://${::fqdn}/ds",
    $key                   = '',
    $cert                  = '',
    $dfn_metadata          = $dariahshibboleth::params::dfn_metadata,
    $federation_enabled    = $dariahshibboleth::params::federation_enabled,
    $edugain_enabled       = $dariahshibboleth::params::edugain_enabled,
    $fakeshibdata          = $dariahshibboleth::params::fakeshibdata,
    $mail_contact          = $dariahshibboleth::params::mail_contact,
    $remote_user_pref_list = $dariahshibboleth::params::remote_user_pref_list,
  ) inherits dariahshibboleth::params {


  class { 'dariahshibboleth::install':
  }->
  class { 'dariahshibboleth::config':
    hostname              => $hostname,
    idp_entityid          => $idp_entityid,
    idp_loginurl          => $idp_loginurl,
    cert                  => $cert,
    key                   => $key,
    dfn_metadata          => $dfn_metadata,
    federation_enabled    => $federation_enabled,
    edugain_enabled       => $edugain_enabled,
    mail_contact          => $mail_contact,
    discoveryurl          => $discoveryurl,
    handlerurl_prefix     => $handlerurl_prefix,
    remote_user_pref_list => $remote_user_pref_list,
  }~>
  class { 'dariahshibboleth::service':
  }

}

