#dariahshibboleth

[![Build Status](https://api.travis-ci.org/DARIAH-DE/puppetmodule-dariahshibboleth.png?branch=master)](https://travis-ci.org/DARIAH-DE/puppetmodule-dariahshibboleth)
[![Coverage Status](https://coveralls.io/repos/DARIAH-DE/puppetmodule-dariahshibboleth/badge.svg?branch=master&service=github)](https://coveralls.io/github/DARIAH-DE/puppetmodule-dariahshibboleth?branch=master)

####Table of Contents

1. [Description](#description)
2. [Setup - The basics of getting started with dariahshibboleth](#setup)
    * [What [modulename] affects](#what-dariahshibboleth-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with dariahshibboleth](#beginning-with-dariahshibboleth)
3. [Usage - Configuration options and additional functionality](#usage)
4. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

##Description

The module provides the setup and configuration of a Shibboleth Service Provider,
specifically targeted at DARIAH integration.

The module sets up a shibboleth service provider configured for DARIAH services.
By default, the module will configure the SP to authenticate against the DARIAH Homeless IdP. 
Alternatively, you can set it up against the DARIAH Test IdP or switch fo full federation setup within DFN AAI.

##Setup

###What dariahshibboleth affects

The module will configure you system to use the SWITCH AAI repository and installs and configures the shib deamon.
The following config files will be affected and set up in the DARIAH style:

* `/etc/shibboleth/attrChecker.html`
* `/etc/shibboleth/attribute-map.xml`
* `/etc/shibboleth/attribute-policy.xml`
* `/etc/shibboleth/shibboleth2.xml`

The module will also provide your SP metadata file
* `/opt/dariahshibboleth/sp-metadata.xml`
and the default 'access denied' page
* `/opt/dariahshibboleth/accessdenied.html`

###Beginning with dariahshibboleth	

The very basic steps needed for a user to get the module up and running.
This can include setup steps, if necessary, or it can be an example of the most basic use of the module.

##Usage

To use the module with DARIAH Homeless IdP only, simply load as
```
class { 'dariahshibboleth': }
```


To configure the Test IdP do
```
class { 'dariahshibboleth': 
  dfn_metadata => 'Test',
  idp_entityid => 'https://ldap-dariah-clone.esc.rzg.mpg.de/idp/shibboleth',
}

```

The module creates the SP's metadata in
```
/etc/shibboleth/sp-metadata.xml
```
which you should copy to your webroot and server under the entityID.


To enable DFN Basic federation with edugain use
```
class { 'dariahshibboleth': 
  dfn_metadata       => 'Basic',
  federation_enabled => true,
  edugain_enabled    => true,
}

```

###Setting up apache
If you want to use Shibboleth with apache, using the `puppetlabs/apache` module, you might need this:

```
$mod_shibd_so = $::apache::apache_version ?
{
  '2.4'   => 'mod_shib_24.so',
  default => 'mod_shib_22.so',
}
package { 'libapache2-mod-shib2': 
  ensure => absent
}
::apache::mod { 'shib2':
  id  => 'mod_shib',
  lib => $mod_shibd_so,
}
```



##Reference

###Classes

####Public Classes
* [`dariahshibboleth`](#class-dariahshibboleth): Installs and configures the Shibboleth SP.

####Private Classes
* [`dariahshibboleth::install`]: Handles the installation of the `shibboleth` package.
* [`dariahshibboleth::configure`]: Handles the configuration.
* [`dariahshibboleth::service`]: Handles the `shibd` service.

###Class: `dariahshibboleth`

####Parameters

#####`cert`
Accepts the cert file for the SP, as created by `shib-keygen`.
It is styrongly recommended to check the certificate's signature algorithm.

#####`dfn_metadata`
The metadata set from DFN to use, valid options are `Test` and `Basic`, default to `Basic`.

#####`discoveryurl`
The URL used in discovery, when using federation.

#####`edugain_enabled`
Set to `true` to enable loading of eduGain Metadata from DFN.
This option is only respected when `dfn_metadata` is `Basic` and `federation_enabled` is `true`.

#####`handlerurl_prefix`
Sets the prefix in the mount path of the SP's HandlerURL.
Defaults to empty string.

#####`hostname`
The hostname used in building the SP metadata, needs to match the cert's fqdn.
Defaults to the system's fully qualified domain name.

#####`idp_entityid`
EntityID of the IdP to use, defaults to the DARIAH Homeless IdP's entityId.
This is used only if not in federation setup for whitelisting.

#####`key`
Accepts the key file for the SP, as created by `shib-keygen`.

#####`mail_contact`
The mail address to be used as contact address in the SP's metadata.
Defaults to `root@localhost`.

#####`remote_user_pref_list`
Accepts a string containing the list of attributes in order of preference for setting the REMOTE_USER variable.
Default to `eppn persistent-id targeted-id`.

##Limitations

The module has been developed and tested with Puppet 3.8 on Ubuntu 14.04.

##Development

Development was carried out with in the DARIAH-DE project, receiving funding from Bundesministerium für Bildung und Forschung (BMBF), 
Förderkennzeichen 01UG1110A bis N.


##Further notes

To customize the metadata, add your values to hiera:
```
dariahshibboleth::MetaData:
  UIInfo_DisplayName_de: 'MY Service'
  UIInfo_Description_de: 'Beschreibung meines Dienstes'
  UIInfo_Description_en: 'Description of my service'
  UIInfo_InformationURL_en: 'http://www.web.site'
  ContactPerson_support_GivenName: 'support'
  Organization_OrganizationName_en: 'MyOrg'
  Organization_OrganizationDisplayName_en: 'My Organisation'
  Organization_OrganizationURL_en: 'http://www.my.org'
  ACS_Hosts:
    - one.host.domain
    - two.host.domain

```

There is basic support for faking shibboleth options to Apache from hiera:
```
dariahshibboleth::FakeCredentials:
  firstname: 'Jane'
  lastname: 'Doe'
  mail: 'jane.doe@example.com'
  eppn: 'JaneDoe@dariah.eu'
  isMemberOf: 'group1;group2'
```
You can access the relevant Apache lines from the variable `$::dariahshibboleth::fakeshibdata`, which defaults to the above.

