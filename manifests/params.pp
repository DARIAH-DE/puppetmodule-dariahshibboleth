# == Class dariahshibboleth::params
#
# Class providing Shibboleth parameters
#
class dariahshibboleth::params {

  $idp_entityid = 'https://ldap-dariah.esc.rzg.mpg.de/idp/shibboleth'
  $idp_loginurl = 'https://ldap-dariah.esc.rzg.mpg.de/Shibboleth.sso/Login'

  $dfn_metadata       = 'Basic'
  $federation_enabled = false
  $edugain_enabled    = false

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

  $md_dn_de = pick($shibd_metadata_hash['UIInfo_DisplayName_de'],$shibd_metadata_hash['UIInfo_DisplayName_en'],'DARIAH')
  $md_dn_en = pick($shibd_metadata_hash['UIInfo_DisplayName_en'],$shibd_metadata_hash['UIInfo_DisplayName_de'],'DARIAH')
  $md_des_de = pick($shibd_metadata_hash['UIInfo_Description_de'],$shibd_metadata_hash['UIInfo_Description_en'],'DARIAH')
  $md_des_en = pick($shibd_metadata_hash['UIInfo_Description_en'],$shibd_metadata_hash['UIInfo_Description_de'],'DARIAH')
  $md_logo_sm = pick($shibd_metadata_hash['UIInfo_Logo_small'],'https://ldap-dariah.esc.rzg.mpg.de/images/DARIAH_flower_icon.png')
  $md_logo_bi = pick($shibd_metadata_hash['UIInfo_Logo_big'],'https://ldap-dariah.esc.rzg.mpg.de/images/DARIAH_flower.png')
  $md_iu_de = pick($shibd_metadata_hash['UIInfo_InformationURL_de'],$shibd_metadata_hash['UIInfo_InformationURL_en'],'http://www.dariah.eu')
  $md_iu_en = pick($shibd_metadata_hash['UIInfo_InformationURL_en'],$shibd_metadata_hash['UIInfo_InformationURL_de'],'http://www.dariah.eu')
  $md_t_gn = pick($shibd_metadata_hash['ContactPerson_technical_GivenName'],$shibd_metadata_hash['ContactPerson_support_GivenName'],'DARIAH Support')
  $md_t_em = pick($shibd_metadata_hash['ContactPerson_technical_EmailAddress'],$shibd_metadata_hash['ContactPerson_support_EmailAddress'],$dariahcommon::adminmail,'root@localhost')
  $md_s_gn = pick($shibd_metadata_hash['ContactPerson_support_GivenName'],$shibd_metadata_hash['ContactPerson_technical_GivenName'],'DARIAH Support')
  $md_s_em = pick($shibd_metadata_hash['ContactPerson_support_EmailAddress'],$shibd_metadata_hash['ContactPerson_technical_EmailAddress'],$dariahcommon::adminmail,'root@localhost')

  $ACS_Hosts = pick($shibd_metadata_hash['ACS_Hosts'],[])

  if $dariahshibboleth::cert {
    $shibcertfilenameonly = regsubst($::dariahshibboleth::cert,'puppet:///modules/','')
    $shibbolethcert = file($shibcertfilenameonly)
  } else {
    $shibbolethcert = ''
  }

}


