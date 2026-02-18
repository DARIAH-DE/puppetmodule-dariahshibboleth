# dariahshibboleth

[![Build Status](https://api.travis-ci.org/DARIAH-DE/puppetmodule-dariahshibboleth.png?branch=master)](https://travis-ci.org/DARIAH-DE/puppetmodule-dariahshibboleth)

## Troubleshooting

In case of metadata or certificate changes, please adapt the metadata URL here: <https://github.com/DARIAH-DE/puppetmodule-dariahshibboleth/blob/ab8839d9f72e0e6cb2ee0bc5f61512852acf86e1/manifests/params.pp#L25C1-L25C108>, see also <https://github.com/DARIAH-DE/puppetmodule-dariahshibboleth/commit/81cd585a8fa99386b13b92e3fb1a75511a06d515>.

## Description

The module provides the setup and configuration of a Shibboleth Service Provider,
specifically targeted at DARIAH integration.

The module sets up a shibboleth service provider configured for DARIAH services.
By default, the module will configure the SP to authenticate against the DARIAH Homeless IdP.
Alternatively, you can set it up against the DARIAH Test IdP or switch fo full federation setup within DFN AAI.

TODO describe AAI Proxy mode

## Setup

The module will configure your system to use the SWITCH AAI repository and installs and configures the shib deamon.
The following config files and templates will be affected and set up for use with DARIAH, in particular the settings as well as the styling:

* `/etc/shibboleth/attrChecker.html`
* `/etc/shibboleth/attribute-map.xml`
* `/etc/shibboleth/attribute-policy.xml`
* `/etc/shibboleth/shibboleth2.xml`
* `/etc/shibboleth/localLogout.html`
* `/etc/shibboleth/metadataError.html`
* `/etc/shibboleth/sessionError.html`

The module will also provide your SP metadata file
* `/opt/dariahshibboleth/sp-metadata.xml`
and the default 'access denied' page
* `/opt/dariahshibboleth/accessdenied.html`

## Usage

To use the module with DARIAH Homeless IdP only, simply load as

```puppet
class { 'dariahshibboleth': }
```

To switch to **eduGAIN federation mode**, simply use

```puppet
class { 'dariahshibboleth':
  federation_enabled => true,
  use_dfn_edugain    => true,
}
```

To configure the **Test IdP** do

```puppet
class { 'dariahshibboleth':
  use_dfn_test            => true,
  idp_entityid            => 'https://stage.idp.de.dariah.eu/simplesaml/saml2/idp/metadata.php',
  federation_enabled      => false,
  discoveryurl            => 'https://auth-integration.de.dariah.eu/CDS/WAYF',
  dariah_registration_url => 'https://auth-integration.de.dariah.eu/Shibboleth.sso/Login?target=/cgi-bin/selfservice/ldapportal.pl%3Fmode%3Dauthenticate%3Bshibboleth%3D1%3Bnextpage%3Dregistration'
}
```
Note that by using `federation_enabled => true` you enable the full Test setup with DFN-Test AAI federation support.

If you want to load metadata from another federation, use `custom_metadata_url` and pass the relevant cert file to `custom_metadata_signature_cert`.
Note, that you will need to provide a compatible `discoveryurl` and that registration at the DARIAH AAI is likely to fail.


The module creates the SP's metadata in

```
/opt/dariahshibboleth/sp-metadata.xml
```

which you should copy to your webroot and server under the entityID.


### Setting up apache
If you want to use Shibboleth with apache, using the `puppetlabs/apache` module, you might need this:

```puppet
::apache::mod { 'shib2':
  id  => 'mod_shib',
  lib => 'mod_shib2.so',
}
package { 'libapache2-mod-shib2':
  ensure => present,
  before => Package['shibboleth'],
}
Service['shibd'] ~> Service['apache2']
```

## Reference

The documentation is available [online](https://dariah-de.github.io/puppetmodule-dariahshibboleth/).


## Limitations

The module has been developed and tested with Puppet 4.9 on Ubuntu 14.04 and 16.04.

## Development

Development was carried out with in the DARIAH-DE project, receiving funding from Bundesministerium für Bildung und Forschung (BMBF),
Förderkennzeichen 01UG1110A bis N und 01UG1610A bis J.


## Further notes

To customize the metadata, add your values to hiera

```yaml
dariahshibboleth::MetaData:
  UIInfo_DisplayName_de: 'MY Service'
  UIInfo_Description_de: 'Beschreibung meines Dienstes'
  UIInfo_Description_en: 'Description of my service'
  UIInfo_InformationURL_en: 'http://www.web.site'
  ContactPerson_support_GivenName: 'support'
  Organization_Name_en: 'MyOrg'
  Organization_DisplayName_en: 'My Organisation'
  Organization_URL_en: 'http://www.my.org'
  ACS_Hosts:
    - one.host.domain
    - two.host.domain
```

There is basic support for faking shibboleth options to Apache from hiera

```yaml
dariahshibboleth::FakeCredentials:
  firstname: 'Jane'
  lastname: 'Doe'
  mail: 'jane.doe@example.com'
  eppn: 'JaneDoe@dariah.eu'
  ismemberof: 'group1;group2'
```

You can access the relevant Apache lines from the variable `$::dariahshibboleth::fakeshibdata`, which defaults to the above.

The module provides option for standby cert and key if you need to perform a rollover in federation use.

