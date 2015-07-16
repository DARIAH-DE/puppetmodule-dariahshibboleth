# == Class dariahshibboleth::install
#
# Class providing Shibboleth installation
#
class dariahshibboleth::install (
  ) inherits dariahshibboleth::params {

  if $::osfamily == 'Debian' {
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
      key         => '294E37D154156E00FB96D7AA26C3C46915B76742',
      key_source  => 'http://pkg.switch.ch/switchaai/SWITCHaai-swdistrib.asc',
      before      => Package['shibboleth'],
    }
  }

  if $::osfamily == 'Suse' {
    if $::lsbdistrelease == '13.2' {
      file {'/etc/zypp/repos.d/security_shibboleth.repo':
        ensure  => present,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        content => '[security_shibboleth]
name=Shibboleth (openSUSE_13.2)
enabled=1
autorefresh=1
type=NONE
keeppackages=1
baseurl=http://download.opensuse.org/repositories/security:/shibboleth/openSUSE_13.2/
',
      }~>
      exec {'import_shibboleth_repo_key':
        path        => [ '/bin', '/usr/bin', '/usr/local/bin' ],
        command     => 'rpm --import http://download.opensuse.org/repositories/security:/shibboleth/openSUSE_13.2/repodata/repomd.xml.key',
        cwd         => '/tmp',
        refreshonly => true,
        require     => File['/etc/zypp/repos.d/security_shibboleth.repo'],
        before      => Exec['zypper_ref'],
      }
    }

  }

  package { 'shibboleth':
    ensure  => 'installed',
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




