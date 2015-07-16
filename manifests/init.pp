# == Class dariahshibboleth
#
# Class providing Shibboleth configuration
# By default, sets up shibd to use DARIAH IdP,
# DFN Test-AAI is supported through dariahshibboleth::federation: 'dfntestaai'
#
class dariahshibboleth (
    $hostname           = $::fqdn,
    $IdP_entityID       = $dariahshibboleth::params::IdP_entityID,
    $IdP_LOGINURL       = $dariahshibboleth::params::IdP_LOGINURL,
    $handlerURL_prefix  = '',
    $discoveryURL       = "https://${::fqdn}/ds4b",
    $key                = '',
    $cert               = '',
    $fakeshib           = false,
    $fakedfirst         = '',
    $fakedlast          = '',
    $fakedmail          = '',
    $fakedisMemberOf    = '',
    $federation         = $dariahshibboleth::params::federation,
  ) inherits dariahshibboleth::params {


  class { 'dariahshibboleth::install':
  }->
  class { 'dariahshibboleth::config':
    cert       => $cert,
    key        => $key,
    federation => $federation,
  }~>
  class { 'dariahshibboleth::service':
  }

}

