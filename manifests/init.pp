# == Class dariahshibboleth
#
# Class providing Shibboleth configuration
# By default, sets up shibd to use DARIAH IdP,
# DFN Test-AAI is supported through dariahshibboleth::federation: 'dfntestaai'
#
class dariahshibboleth (
    $enable             = true,
    $hostname           = $::fqdn,
    $key                = '',
    $cert               = '',
    $fakeshib           = false,
    $fakedfirst         = '',
    $fakedlast          = '',
    $fakedmail          = '',
    $fakedisMemberOf    = '',
    $custommetadatafile = '',
    $federation         = '',
    $extend_MetadataGenerator = false,
  ) {


  include 'dariahshibboleth::install'
  include 'dariahshibboleth::config'
  include 'dariahshibboleth::metadata'


}

