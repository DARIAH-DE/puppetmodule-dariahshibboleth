# This class provides the dariahshibboleth module.
# It installs and configures the SP.
#
# @param dfn_metadata The DFN metadata set to use.
# @param cert The shibboleth SP's key.
# @param discoveryurl
# @param edugain_enabled Enables the use of eduGain metafederation.
# @param federation_enabled Enables the use of federation metadata.
# @param handlerssl Accepts true or false for Shibboleth's setting
# @param handlerurl_prefix Mountpoint of the shibboleth handler.
# @param hostname The hostname to use in building the SP metadata.
# @param idp_entityid The enityID of the IdP to use.
# @param federation_registration_url URL of the registration form for federation users
# @param key The shibboleth SP's key.
# @param mail_contact The contact mail address for metadata.
# @param remote_user_pref_list The preference list for REMOTE_USER.
# @param attribute_checker_flushsession Whether to flush AttributeChecker's session
# @param locallogout_headertags Additional header tags for localLogout.html
#
class dariahshibboleth (
    $hostname                       = $::fqdn,
    $idp_entityid                   = $dariahshibboleth::params::idp_entityid,
    $federation_registration_url    = $dariahshibboleth::params::federation_registration_url,
    $handlerurl_prefix              = undef,
    $discoveryurl                   = "https://${::fqdn}/ds",
    $key                            = undef,
    $cert                           = undef,
    $dfn_metadata                   = $dariahshibboleth::params::dfn_metadata,
    $federation_enabled             = $dariahshibboleth::params::federation_enabled,
    $edugain_enabled                = $dariahshibboleth::params::edugain_enabled,
    $fakeshibdata                   = $dariahshibboleth::params::fakeshibdata,
    $mail_contact                   = $dariahshibboleth::params::mail_contact,
    $remote_user_pref_list          = $dariahshibboleth::params::remote_user_pref_list,
    $locallogout_headertags         = undef,
    $handlerssl                     = true,
    $attribute_checker_flushsession = true,
  ) inherits dariahshibboleth::params {

  anchor { 'dariahshibboleth::begin': } ->
  class { '::dariahshibboleth::install':
  }->
  class { '::dariahshibboleth::config':
    hostname                       => $hostname,
    idp_entityid                   => $idp_entityid,
    federation_registration_url    => $federation_registration_url,
    cert                           => $cert,
    key                            => $key,
    dfn_metadata                   => $dfn_metadata,
    federation_enabled             => $federation_enabled,
    edugain_enabled                => $edugain_enabled,
    mail_contact                   => $mail_contact,
    discoveryurl                   => $discoveryurl,
    handlerurl_prefix              => $handlerurl_prefix,
    handlerssl                     => $handlerssl,
    remote_user_pref_list          => $remote_user_pref_list,
    attribute_checker_flushsession => $attribute_checker_flushsession,
    locallogout_headertags         => $locallogout_headertags,
  }~>
  class { '::dariahshibboleth::service':
  }->
  anchor { 'dariahshibboleth::end': }

}
