# This class provides the dariahshibboleth module.
# It installs and configures the SP.
#
# @param attribute_checker_flushsession Whether to flush AttributeChecker's session
# @param cert The shibboleth SP's key.
# @param dfn_metadata The DFN metadata set to use.
# @param discoveryurl The URL of the Discovery Service / WAYF
# @param edugain_enabled Enables the use of eduGain metafederation.
# @param fakeshibdata Hash of fake shibboleth session data
# @param federation_enabled Enables the use of federation metadata.
# @param federation_registration_url URL of the registration form for federation users
# @param handlerssl Accepts true or false for Shibboleth's setting
# @param handlerurl_prefix Mountpoint of the shibboleth handler.
# @param hostname The hostname to use in building the SP metadata.
# @param idp_entityid The enityID of the IdP to use.
# @param key The shibboleth SP's key.
# @param locallogout_headertags Additional header tags for localLogout.html
# @param mail_contact The contact mail address for metadata.
# @param remote_user_pref_list The preference list for REMOTE_USER.
#
class dariahshibboleth (
    $attribute_checker_flushsession = $dariahshibboleth::params::attribute_checker_flushsession,
    $cert                           = undef,
    $dfn_metadata                   = $dariahshibboleth::params::dfn_metadata,
    $discoveryurl                   = $dariahshibboleth::params::discoveryurl,
    $edugain_enabled                = $dariahshibboleth::params::edugain_enabled,
    $fakeshibdata                   = $dariahshibboleth::params::fakeshibdata,
    $federation_enabled             = $dariahshibboleth::params::federation_enabled,
    $federation_registration_url    = $dariahshibboleth::params::federation_registration_url,
    $handlerssl                     = $dariahshibboleth::params::handlerssl,
    $handlerurl_prefix              = undef,
    $hostname                       = $::fqdn,
    $idp_entityid                   = $dariahshibboleth::params::idp_entityid,
    $key                            = undef,
    $locallogout_headertags         = undef,
    $mail_contact                   = $dariahshibboleth::params::mail_contact,
    $remote_user_pref_list          = $dariahshibboleth::params::remote_user_pref_list,
) inherits dariahshibboleth::params {

  anchor { 'dariahshibboleth::begin': } ->
  class { '::dariahshibboleth::install':}->
  class { '::dariahshibboleth::config': }~>
  class { '::dariahshibboleth::service': }->
  anchor { 'dariahshibboleth::end': }

}

