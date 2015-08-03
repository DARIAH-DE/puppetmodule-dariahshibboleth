# This private class sets up the shibd service.
#
class dariahshibboleth::service (
) {

  service { 'shibd':
    ensure     => 'running',
    hasrestart => true,
    hasstatus  => false,
  }

}


