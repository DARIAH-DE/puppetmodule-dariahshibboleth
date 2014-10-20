# == Class dariahshibboleth::install
#
# Class providing Shibboleth installation
#
class dariahshibboleth::install (
  ) {

  if $dariahshibboleth::enable {

    $switch_repo_location = $::lsbdistid ?
    {
      'Ubuntu' => 'http://pkg.switch.ch/switchaai/ubuntu',
      'Debian' => 'http://pkg.switch.ch/switchaai/debian',
      default  => undef,
    }

    apt::source { 'SWITCHaai-swdistrib':
      location    => $switch_repo_location,
      repos       => 'main',
      include_src => false,
      key         => '26C3C46915B76742',
      key_source  => 'http://pkg.switch.ch/switchaai/SWITCHaai-swdistrib.asc',
    }

    package { 'shibboleth':
      ensure  => 'installed',
      require => Apt::Source['SWITCHaai-swdistrib'],
    }

    service { 'shibd':
      ensure     => 'running',
      require    => Package['shibboleth'],
      hasrestart => true,
      hasstatus  => false,
    }

    file { '/opt/dariahshibboleth':
      ensure => directory,
      owner  => root,
      group  => root,
      mode   => '0755',
    }

    file { '/opt/dariahshibboleth/accessdenied.html':
      ensure  => directory,
      owner   => root,
      group   => root,
      mode    => '0644',
      source  => 'puppet:///modules/dariahshibboleth/opt/dariahshibboleth/accessdenied.html',
      require => File['/opt/dariahshibboleth'],
    }

  }
}




