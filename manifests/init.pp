# This class provides the dariahshibboleth module.
# It installs and configures the SP.
#
# @param attribute_checker_flushsession Whether to flush AttributeChecker's session
# @param cert The shibboleth SP's key.
# @param custom_metadata_url URL from where to get federation metadata
# @param custom_metadata_signature_cert File containing the public cert to verify the metadata
# @param discoveryurl The URL of the Discovery Service / WAYF
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
# @param metadata_signature_cert Puppet source of the metadata's signature
# @param remote_user_pref_list The preference list for REMOTE_USER.
# @param standby_cert standby Shibboleth SP cert for rollover
# @param standby_key standby Shibboleth SP key for rollover
# @param use_edugain Load the eduGAIN Metadata
# @param use_dfn_basic Load the DFN-Basic AAI Metadata
# @param use_dfn_test Load the DFN-Test AAI Metadata
# @param use_dfn_edugain Load the eduGAIN Metadata from DFN (without DFN!)
#
class dariahshibboleth (
    $attribute_checker_flushsession = $dariahshibboleth::params::attribute_checker_flushsession,
    $cert                           = undef,
    $custom_metadata_url            = $dariahshibboleth::params::custom_metadata_url,
    $custom_metadata_signature_cert = $dariahshibboleth::params::custom_metadata_signature_cert,
    $discoveryurl                   = $dariahshibboleth::params::discoveryurl,
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
    $standby_cert                   = undef,
    $standby_key                    = undef,
    $use_edugain                    = $dariahshibboleth::params::use_edugain,
    $use_dfn_basic                  = $dariahshibboleth::params::use_dfn_basic,
    $use_dfn_test                   = $dariahshibboleth::params::use_dfn_test,
    $use_dfn_edugain                = $dariahshibboleth::params::use_dfn_edugain,
) inherits dariahshibboleth::params {

  anchor { 'dariahshibboleth::begin': } ->
  class { '::dariahshibboleth::install':}->
  class { '::dariahshibboleth::config': }~>
  class { '::dariahshibboleth::service': }->
  anchor { 'dariahshibboleth::end': }

}

