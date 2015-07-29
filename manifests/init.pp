# == Class dariahshibboleth
#
# Class providing Shibboleth configuration
# By default, sets up shibd to use DARIAH IdP,
# DFN Test-AAI is supported through dariahshibboleth::federation: 'dfntestaai'
#
class dariahshibboleth (
    $hostname           = $::fqdn,
    $idp_entityid       = $dariahshibboleth::params::idp_entityid,
    $idp_loginurl       = $dariahshibboleth::params::idp_loginurl,
    $handlerurl_prefix  = '',
    $discoveryurl       = "https://${::fqdn}/ds4b",
    $key                = '',
    $cert               = '',
    $fakeshib           = false,
    $fakedfirst         = '',
    $fakedlast          = '',
    $fakedmail          = '',
    $fakedisMemberOf    = '',
    $dfn_metadata       = $dariahshibboleth::params::dfn_metadata,
    $federation_enabled = $dariahshibboleth::params::federation_enabled,
    $edugain_enabled    = $dariahshibboleth::params::edugain_enabled,
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

