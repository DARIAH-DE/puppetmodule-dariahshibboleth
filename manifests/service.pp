# == Class dariahshibboleth::service
#
# Class providing Shibboleth service
#
class dariahshibboleth::service (
  $enable = false,
  ) {

  if $enable {
    service { 'shibd':
      ensure     => 'running',
      require    => Package['shibboleth'],
      hasrestart => true,
      hasstatus  => false,
    }

  }

}


