# == Class dariahshibboleth::metadata
#
# Class providing Shibboleth metadata configuration options
#
class dariahshibboleth::metadata (
  ) {

  $fakeshibdata = "
    SetEnv cn \"${dariahshibboleth::fakedfirst} ${dariahshibboleth::fakedlast}\"
    SetEnv eppn \"${dariahshibboleth::fakedfirst}${dariahshibboleth::fakedlast}@dariah.eu\"
    SetEnv givenName \"${dariahshibboleth::fakedfirst}\"
    SetEnv mail \"${dariahshibboleth::fakedmail}\"
    SetEnv isMemberOf \"${dariahshibboleth::fakedisMemberOf}\"
    SetEnv sn \"${dariahshibboleth::fakedlast}\"
    SetEnv REMOTE_USER \"${dariahshibboleth::fakedfirst}${dariahshibboleth::fakedlast}@dariah.eu\"
    SetEnv Shib-Session-Index \"_11223344556677889900aabbccddeeff\"
    SetEnv Shib-Session-ID \"_11223344556677889900aabbccddeeff\"
  "

  $shibd_metadata_hash = hiera_hash('dariahshibboleth::MetaData',{no => 'data'})

  if $dariahshibboleth::extend_MetadataGenerator {

    $mg_a_dn_de = pick($shibd_metadata_hash['UIInfo_DisplayName_de'],$shibd_metadata_hash['UIInfo_DisplayName_en'],'DARIAH')
    $mg_a_dn_en = pick($shibd_metadata_hash['UIInfo_DisplayName_en'],$shibd_metadata_hash['UIInfo_DisplayName_de'],'DARIAH')
    $mg_a_des_de = pick($shibd_metadata_hash['UIInfo_Description_de'],$shibd_metadata_hash['UIInfo_Description_en'],'DARIAH')
    $mg_a_des_en = pick($shibd_metadata_hash['UIInfo_Description_en'],$shibd_metadata_hash['UIInfo_Description_de'],'DARIAH')
    $mg_a_logo_sm = pick($shibd_metadata_hash['UIInfo_Logo_small'],'https://ldap-dariah.esc.rzg.mpg.de/images/DARIAH_flower_icon.png')
    $mg_a_logo_bi = pick($shibd_metadata_hash['UIInfo_Logo_big'],'https://ldap-dariah.esc.rzg.mpg.de/images/DARIAH_flower.png')
    $mg_a_iu_de = pick($shibd_metadata_hash['UIInfo_InformationURL_de'],$shibd_metadata_hash['UIInfo_InformationURL_en'],'http://www.dariah.eu')
    $mg_a_iu_en = pick($shibd_metadata_hash['UIInfo_InformationURL_en'],$shibd_metadata_hash['UIInfo_InformationURL_de'],'http://www.dariah.eu')
    $mg_cp_t_gn = pick($shibd_metadata_hash['ContactPerson_technical_GivenName'],$shibd_metadata_hash['ContactPerson_support_GivenName'],'DARIAH Support')
    $mg_cp_t_em = pick($shibd_metadata_hash['ContactPerson_technical_EmailAddress'],$shibd_metadata_hash['ContactPerson_support_EmailAddress'],$dariahcommon::adminmail)
    $mg_cp_s_gn = pick($shibd_metadata_hash['ContactPerson_support_GivenName'],$shibd_metadata_hash['ContactPerson_technical_GivenName'],'DARIAH Support')
    $mg_cp_s_em = pick($shibd_metadata_hash['ContactPerson_support_EmailAddress'],$shibd_metadata_hash['ContactPerson_technical_EmailAddress'],$dariahcommon::adminmail)

    $metadatagenerator_argumente = "
              <md:RequestedAttribute FriendlyName=\"eduPersonPrincipalName\" Name=\"urn:mace:dir:attribute-def:eduPersonPrincipalName\" NameFormat=\"urn:mace:shibboleth:1.0:attributeNamespace:uri\" isRequired=\"true\"/>
              <md:RequestedAttribute FriendlyName=\"eduPersonPrincipalName\" Name=\"urn:oid:1.3.6.1.4.1.5923.1.1.1.6\" NameFormat=\"urn:oasis:names:tc:SAML:2.0:attrname-format:uri\" isRequired=\"true\"/>
              <mdattr:EntityAttributes xmlns:mdattr=\"urn:oasis:names:tc:SAML:metadata:attribute\">
                <saml:Attribute Name=\"http://macedir.org/entity-category\" NameFormat=\"urn:oasis:names:tc:SAML:2.0:attrname-format:uri\">
                  <saml:AttributeValue>http://www.geant.net/uri/dataprotection-code-of-conduct/v1</saml:AttributeValue>
                </saml:Attribute>
              </mdattr:EntityAttributes>
              <mdui:UIInfo xmlns:mdui=\"urn:oasis:names:tc:SAML:metadata:ui\">
                <mdui:DisplayName xml:lang=\"de\">${mg_a_dn_de}</mdui:DisplayName>
                <mdui:DisplayName xml:lang=\"en\">${mg_a_dn_en}</mdui:DisplayName>
                <mdui:Description xml:lang=\"de\">${mg_a_des_de}</mdui:Description>
                <mdui:Description xml:lang=\"en\">${mg_a_des_en}</mdui:Description>
                <mdui:Logo height=\"16\" width=\"16\">${mg_a_logo_sm}</mdui:Logo>
                <mdui:Logo height=\"154\" width=\"160\">${mg_a_logo_bi}</mdui:Logo>
                <mdui:InformationURL xml:lang=\"de\">${mg_a_iu_de}</mdui:InformationURL>
                <mdui:InformationURL xml:lang=\"en\">${mg_a_iu_en}</mdui:InformationURL>
                <mdui:PrivacyStatementURL xml:lang=\"en\">https://de.dariah.eu/ServicePrivacyPolicy</mdui:PrivacyStatementURL>
              </mdui:UIInfo>
              <md:ContactPerson contactType=\"technical\">
                <md:GivenName>${mg_cp_t_gn}</md:GivenName>
                <md:EmailAddress>${mg_cp_t_em}</md:EmailAddress>
              </md:ContactPerson>
              <md:ContactPerson contactType=\"support\"> 
                <md:GivenName>${mg_cp_s_gn}</md:GivenName> 
                <md:EmailAddress>${mg_cp_s_em}</md:EmailAddress> 
              </md:ContactPerson>
  "
  }
  else {
    $metadatagenerator_argumente = ''
  }

  $md_dn_de = pick($shibd_metadata_hash['UIInfo_DisplayName_de'],$shibd_metadata_hash['UIInfo_DisplayName_en'],'DARIAH')
  $md_dn_en = pick($shibd_metadata_hash['UIInfo_DisplayName_en'],$shibd_metadata_hash['UIInfo_DisplayName_de'],'DARIAH')
  $md_des_de = pick($shibd_metadata_hash['UIInfo_Description_de'],$shibd_metadata_hash['UIInfo_Description_en'],'DARIAH')
  $md_des_en = pick($shibd_metadata_hash['UIInfo_Description_en'],$shibd_metadata_hash['UIInfo_Description_de'],'DARIAH')
  $md_logo_sm = pick($shibd_metadata_hash['UIInfo_Logo_small'],'https://ldap-dariah.esc.rzg.mpg.de/images/DARIAH_flower_icon.png')
  $md_logo_bi = pick($shibd_metadata_hash['UIInfo_Logo_big'],'https://ldap-dariah.esc.rzg.mpg.de/images/DARIAH_flower.png')
  $md_iu_de = pick($shibd_metadata_hash['UIInfo_InformationURL_de'],$shibd_metadata_hash['UIInfo_InformationURL_en'],'http://www.dariah.eu')
  $md_iu_en = pick($shibd_metadata_hash['UIInfo_InformationURL_en'],$shibd_metadata_hash['UIInfo_InformationURL_de'],'http://www.dariah.eu')
  $md_t_gn = pick($shibd_metadata_hash['ContactPerson_technical_GivenName'],$shibd_metadata_hash['ContactPerson_support_GivenName'],'DARIAH Support')
  $md_t_em = pick($shibd_metadata_hash['ContactPerson_technical_EmailAddress'],$shibd_metadata_hash['ContactPerson_support_EmailAddress'],$dariahcommon::adminmail)
  $md_s_gn = pick($shibd_metadata_hash['ContactPerson_support_GivenName'],$shibd_metadata_hash['ContactPerson_technical_GivenName'],'DARIAH Support')
  $md_s_em = pick($shibd_metadata_hash['ContactPerson_support_EmailAddress'],$shibd_metadata_hash['ContactPerson_technical_EmailAddress'],$dariahcommon::adminmail)

  $ACS_Hosts = pick($shibd_metadata_hash['ACS_Hosts'],[])

  $shibcertfilenameonly = regsubst($::dariahshibboleth::cert,'puppet:///modules/','')
  $shibbolethcert = file($shibcertfilenameonly)

  if $dariahshibboleth::enable {

    file {'/var/www/ShibbolethMetadata.xml':
      ensure  => present,
      owner   => root,
      group   => root,
      mode    => '0644',
      content => template('dariahshibboleth/var/www/ShibbolethMetadata.xml.erb'),
    }

    file { '/etc/shibboleth/dariah-idp-metadata.xml':
      ensure  => present,
      owner   => root,
      group   => root,
      mode    => '0644',
      source  => 'puppet:///modules/dariahshibboleth/etc/shibboleth/dariah-idp-metadata.xml',
      require => Package['shibboleth'],
      notify  => Service['shibd'],
    }

    if $dariahshibboleth::custommetadatafile != '' {
      file { '/opt/dariahshibboleth/sp-metadata.xml':
        ensure  => present,
        owner   => root,
        group   => root,
        mode    => '0644',
        source  => $dariahshibboleth::custommetadatafile,
        require => File['/opt/dariahshibboleth'],
      }
    }


  }
}




