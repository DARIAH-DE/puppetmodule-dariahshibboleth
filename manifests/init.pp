# == Class dariahshibboleth
#
# Class providing Shibboleth configuration
# By default, sets up shibd to use DARIAH IdP,
# DFN Test-AAI is supported through dariahshibboleth::federation: 'dfntestaai'
#
class dariahshibboleth (
    $enable             = true,
    $hostname           = $::fqdn,
    $IdP_entityID       = 'https://ldap-dariah.esc.rzg.mpg.de/idp/shibboleth',
    $IdP_LOGINURL       = 'https://ldap-dariah.esc.rzg.mpg.de/Shibboleth.sso/Login',
    $key                = '',
    $cert               = '',
    $fakeshib           = false,
    $fakedfirst         = '',
    $fakedlast          = '',
    $fakedmail          = '',
    $fakedisMemberOf    = '',
    $federation         = '',
  ) {


  include 'dariahshibboleth::install'
  include 'dariahshibboleth::config'
  include 'dariahshibboleth::metadata'


}

