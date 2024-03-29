# This private class installs the shibboleth SP.
#
class dariahshibboleth::install inherits dariahshibboleth {

  case $facts['os']['family'] {
    'Debian': {
      if ($::lsbdistcodename == 'bionic' or $::lsbdistcodename == 'focal'
      or $::lsbdistcodename == 'xenial') {
      $switch_repo_location = $facts['os']['name'] ?
      {
        'Ubuntu' => 'http://pkg.switch.ch/switchaai/ubuntu',
        'Debian' => 'http://pkg.switch.ch/switchaai/debian',
        default  => undef,
      }

      apt::source { 'SWITCHaai-swdistrib':
        location => $switch_repo_location,
        repos    => 'main',
        key      => {
          'id'     => '294E37D154156E00FB96D7AA26C3C46915B76742',
          'source' => 'http://pkg.switch.ch/switchaai/SWITCHaai-swdistrib.asc',
        },
        include  => {
          'src' => false,
        },
        before   => Package['shibboleth'],
      }
    }
    }
    default: {
      fail("Module dariahshibboleth does not support ${facts['os']['family']}!")
    }
  }

  package { 'shibboleth':
    ensure  => 'installed',
  }

  file { '/opt/dariahshibboleth':
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }
  -> file { '/opt/dariahshibboleth/accessdenied.html':
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    source => 'puppet:///modules/dariahshibboleth/opt/dariahshibboleth/accessdenied.html',
  }

}



