# This class provides the dariahshibboleth module.
# It installs and configures the SP.
#
# @param attribute_checker_flushsession Whether to flush AttributeChecker's session
# @param attribute_checker_requiredattributes Array of attributes required from the IdP, if absent the user is sent to DARIAH registration.
#   Defaults to `['eppn','mail','givenName','sn']`.
# @param cert Accepts the cert file for the SP, as created by `shib-keygen`.
#   It is styrongly recommended to check the certificate's signature algorithm.
# @param custom_metadata_url URL from where to get federation metadata.
# @param custom_metadata_signature_cert Puppet file source containing the public cert to verify the metadata.
# @param dariah_registration_url The URL where to send users to register with DARIAH and update their data.
# @param discoveryurl The URL of the Discovery Service / WAYF, defaults to the DARIAH CDS.
# @param disable_attribute_checker Whether to completely disable the AttributeChecker (use with care!)
# @param fakeshibdata Hash of fake shibboleth session data.
# @param federation_enabled Whether to enable full federation support.
# @param handlerssl Whether to use SSL for the Shibboleth handler.
#   Defaults to `true` and should not be changed unless you are very sure.
# @param handlerurl_prefix Sets the prefix in the mount path of the SP's HandlerURL.
# @param hostname The hostname used in building the SP metadata, needs to match the cert's fqdn.
#  Defaults to the system's fully qualified domain name.
# @param idp_entityid EntityID of the IdP to use, defaults to the DARIAH Homeless IdP's entityId.
#   This is used only if not in federation setup for whitelisting.
# @param key Accepts the key file for the SP, as created by `shib-keygen`..
# @param locallogout_headertags Additional header tags to insert into localLogout.html.
# @param loggersyslog Switch to syslog logging
# @param mail_contact The mail address to be used as contact address in the SP's metadata.
# @param remote_user_pref_list Accepts a string containing the list of attributes in order of preference for setting the `REMOTE_USER` variable.
#   Default to `eppn persistent-id targeted-id`.
# @param standby_cert Standby Shibboleth SP cert for rollover migration.
# @param standby_key Standby Shibboleth SP key for rollover migration.
# @param tou_enforced Whether to enforce acceptance of DARIAH ToU.
# @param tou_sp_tou_group SP specific ToU's group, only active if `tou_enforced=true`.
# @param tou_sp_tou_name SP specif ToU's name, only active if `tou_enforced=true`.
# @param use_dfn_basic Load the DFN-Basic AAI Metadata.
# @param use_dfn_test Load the DFN-Test AAI Metadata.
# @param use_dfn_edugain Load the eduGAIN Metadata from DFN (without DFN!).
# @param use_proxy Switch to AAI Proxy mode
#
class dariahshibboleth (
  Boolean $attribute_checker_flushsession          = $dariahshibboleth::params::attribute_checker_flushsession,
  Array   $attribute_checker_requiredattributes    = $dariahshibboleth::params::attribute_checker_requiredattributes,
  Optional[String] $cert                           = undef,
  Optional[String] $custom_metadata_url            = $dariahshibboleth::params::custom_metadata_url,
  Optional[String] $custom_metadata_signature_cert = $dariahshibboleth::params::custom_metadata_signature_cert,
  String  $dariah_registration_url                 = $dariahshibboleth::params::dariah_registration_url,
  String  $discoveryurl                            = $dariahshibboleth::params::discoveryurl,
  Boolean $disable_attribute_checker               = $dariahshibboleth::params::disable_attribute_checker,
  String  $fakeshibdata                            = $dariahshibboleth::params::fakeshibdata,
  Boolean $federation_enabled                      = $dariahshibboleth::params::federation_enabled,
  Boolean $handlerssl                              = $dariahshibboleth::params::handlerssl,
  Optional[String] $handlerurl_prefix              = undef,
  String  $hostname                                = $facts['networking']['fqdn'],
  String  $idp_entityid                            = $dariahshibboleth::params::idp_entityid,
  Optional[String] $key                            = undef,
  Optional[String] $locallogout_headertags         = undef,
  Boolean $loggersyslog                            = $dariahshibboleth::params::loggersyslog,
  String  $mail_contact                            = $dariahshibboleth::params::mail_contact,
  String  $remote_user_pref_list                   = $dariahshibboleth::params::remote_user_pref_list,
  Optional[String] $standby_cert                   = undef,
  Optional[String] $standby_key                    = undef,
  Boolean $tou_enforced                            = $dariahshibboleth::params::tou_enforced,
  Optional[String] $tou_sp_tou_group               = undef,
  Optional[String] $tou_sp_tou_name                = undef,
  Boolean $use_dfn_basic                           = $dariahshibboleth::params::use_dfn_basic,
  Boolean $use_dfn_test                            = $dariahshibboleth::params::use_dfn_test,
  Boolean $use_dfn_edugain                         = $dariahshibboleth::params::use_dfn_edugain,
  Boolean $use_proxy                               = $dariahshibboleth::params::use_proxy,
) inherits dariahshibboleth::params {

  anchor { 'dariahshibboleth::begin': }
  -> class { '::dariahshibboleth::install': }
  -> class { '::dariahshibboleth::config': }
  ~> class { '::dariahshibboleth::service': }
  -> anchor { 'dariahshibboleth::end': }

}

