# This class provides the dariahshibboleth module.
# It installs and configures the SP.
#
# @param attribute_checker_flushsession Whether to flush AttributeChecker's session
# @param attribute_checker_requiredattributes Array of attributes required from IdP.
# @param cert The shibboleth SP's key.
# @param custom_metadata_url URL from where to get federation metadata.
# @param custom_metadata_signature_cert File containing the public cert to verify the metadata.
# @param dariah_registration_url URL of the registration form for federation users.
# @param discoveryurl The URL of the Discovery Service / WAYF.
# @param fakeshibdata Hash of fake shibboleth session data.
# @param federation_enabled Enables the use of federation metadata.
# @param handlerssl Accepts true or false for Shibboleth's setting.
# @param handlerurl_prefix Mountpoint of the shibboleth handler.
# @param hostname The hostname to use in building the SP metadata.
# @param idp_entityid The enityID of the IdP to use.
# @param key The shibboleth SP's key.
# @param locallogout_headertags Additional header tags for localLogout.html.
# @param mail_contact The contact mail address for metadata.
# @param remote_user_pref_list The preference list for REMOTE_USER.
# @param standby_cert standby Shibboleth SP cert for rollover.
# @param standby_key standby Shibboleth SP key for rollover.
# @param standby_key standby Shibboleth SP key for rollover.
# @param tou_additional_tous Array of additonal ToU to be enforced..
# @param tou_enforced Whether to enforce acceptance of DARIAH ToU.
# @param use_dfn_basic Load the DFN-Basic AAI Metadata.
# @param use_dfn_test Load the DFN-Test AAI Metadata.
# @param use_dfn_edugain Load the eduGAIN Metadata from DFN (without DFN!).
# @param use_edugain Whether to load eduGAIN directly.
#
class dariahshibboleth (
  Boolean $attribute_checker_flushsession          = $dariahshibboleth::params::attribute_checker_flushsession,
  Array   $attribute_checker_requiredattributes    = $dariahshibboleth::params::attribute_checker_requiredattributes,
  Optional[String] $cert                           = undef,
  Optional[String] $custom_metadata_url            = $dariahshibboleth::params::custom_metadata_url,
  Optional[String] $custom_metadata_signature_cert = $dariahshibboleth::params::custom_metadata_signature_cert,
  String  $dariah_registration_url                 = $dariahshibboleth::params::dariah_registration_url,
  String  $discoveryurl                            = $dariahshibboleth::params::discoveryurl,
  String  $fakeshibdata                            = $dariahshibboleth::params::fakeshibdata,
  Boolean $federation_enabled                      = $dariahshibboleth::params::federation_enabled,
  Boolean $handlerssl                              = $dariahshibboleth::params::handlerssl,
  Optional[String] $handlerurl_prefix              = undef,
  String  $hostname                                = $facts['networking']['fqdn'],
  String  $idp_entityid                            = $dariahshibboleth::params::idp_entityid,
  Optional[String] $key                            = undef,
  Optional[String] $locallogout_headertags         = undef,
  String  $mail_contact                            = $dariahshibboleth::params::mail_contact,
  String  $remote_user_pref_list                   = $dariahshibboleth::params::remote_user_pref_list,
  Optional[String] $standby_cert                   = undef,
  Optional[String] $standby_key                    = undef,
  Array   $tou_additional_tous                     = $dariahshibboleth::params::tou_additional_tous,
  Boolean $tou_enforced                            = $dariahshibboleth::params::tou_enforced,
  Boolean $use_edugain                             = $dariahshibboleth::params::use_edugain,
  Boolean $use_dfn_basic                           = $dariahshibboleth::params::use_dfn_basic,
  Boolean $use_dfn_test                            = $dariahshibboleth::params::use_dfn_test,
  Boolean $use_dfn_edugain                         = $dariahshibboleth::params::use_dfn_edugain,
) inherits dariahshibboleth::params {

  anchor { 'dariahshibboleth::begin': } ->
  class { '::dariahshibboleth::install':}->
  class { '::dariahshibboleth::config': }~>
  class { '::dariahshibboleth::service': }->
  anchor { 'dariahshibboleth::end': }

}

