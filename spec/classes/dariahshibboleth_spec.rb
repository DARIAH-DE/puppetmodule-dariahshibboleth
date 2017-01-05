require 'spec_helper'

describe "dariahshibboleth" do
  let(:facts) { {:osfamily => 'Debian', :lsbdistid => 'Ubuntu', :lsbdistcodename => 'trusty', :lsbdistrelease => '14.04'} }

  it { should contain_anchor('dariahshibboleth::begin').that_comes_before('Class[dariahshibboleth::install]') }
  it { should contain_class('dariahshibboleth::install').that_comes_before('Class[dariahshibboleth::config]') }
  it { should contain_class('dariahshibboleth::config').that_notifies('Class[dariahshibboleth::service]') }
  it { should contain_class('dariahshibboleth::service').that_comes_before('Anchor[dariahshibboleth::end]') }
  it { should contain_class('dariahshibboleth::params') }
  it { should contain_anchor('dariahshibboleth::end') }

  context 'ubuntu trusty system' do
    let(:facts) { {:osfamily => 'Debian', :lsbdistid => 'Ubuntu', :lsbdistcodename => 'trusty', :lsbdistrelease => '14.04'} }
    it do
      should contain_apt__source('SWITCHaai-swdistrib').with({
        'location' => 'http://pkg.switch.ch/switchaai/ubuntu',
        'key'      => '294E37D154156E00FB96D7AA26C3C46915B76742',
      })
    end
  end

  it do
    should contain_package('shibboleth')
  end

  it do
    should contain_file('/opt/dariahshibboleth') \
      .with_ensure('directory')
  end
  it do
    should contain_file('/opt/dariahshibboleth/accessdenied.html')
  end


  context 'default settings' do
    it do
      should contain_file('/etc/shibboleth/attribute-map.xml')
    end
    it do
      should contain_file('/etc/shibboleth/attribute-policy.xml')
    end
    it do
      should contain_file('/etc/shibboleth/attrChecker.html')
    end
    it do
      should contain_file('/etc/shibboleth/edugain-mds.pem')
    end
    it do
      should contain_file('/etc/shibboleth/dfn-aai.pem')
    end
    it do
      should contain_file('/etc/shibboleth/localLogout.html')
    end
    it do
      should contain_file('/etc/shibboleth/metadataError.html')
    end
    it do
      should contain_file('/etc/shibboleth/sessionError.html')
    end
    it do
      should contain_file('/etc/shibboleth/shibboleth2.xml') \
        .with_content(/handlerSSL="true" cookieProps="https"/)
    end

  end

  context 'with hostname set' do
    let(:params) { {:hostname => 'foobar'} }
    it do
      should contain_file('/etc/shibboleth/shibboleth2.xml') \
        .with_content(/<ApplicationDefaults entityID="https:\/\/foobar\/shibboleth"/)
    end
  end

  context 'with federation_enabled => true' do
    let(:params) { {:federation_enabled => true, :idp_entityid => 'foobar', :discoveryurl => 'barfoo'} }
    it do
      should contain_file('/etc/shibboleth/shibboleth2.xml') \
        .with_content(/<Handler type="AttributeChecker"/) \
        .with_content(/AttributeResolver type="SimpleAggregation"/) \
        .with_content(/sessionHook="\/Shibboleth\.sso\/AttrChecker">/) \
        .with_content(/<SSO discoveryProtocol="SAMLDS" discoveryURL="barfoo">/) \
        .with_content(/flushSession="true"/)
    end
  end

  context 'with federation_enabled => true and attribute_checker_flushsession => false' do
    let(:params) { {:federation_enabled => true, :attribute_checker_flushsession => false} }
    it do
      should contain_file('/etc/shibboleth/shibboleth2.xml') \
        .with_content(/<Handler type="AttributeChecker"/) \
        .with_content(/flushSession="false"/)
    end
  end

  context 'with federation_enabled => false' do
    let(:params) { {:federation_enabled => false, :idp_entityid => 'foobar'} }
    it do
      should contain_file('/etc/shibboleth/shibboleth2.xml') \
        .with_content(/MetadataFilter type="Whitelist"/) \
        .with_content(/<SSO entityID="foobar">/)
    end
  end

  context 'with dfn basic enabled' do
    let(:params) { {:use_dfn_basic => true} }
    it do
      should contain_file('/etc/shibboleth/shibboleth2.xml') \
        .with_content(/<MetadataProvider type="XML" uri="https:\/\/www.aai.dfn.de\/fileadmin\/metadata\/DFN-AAI-Basic-metadata.xml"/)
    end
  end

  context 'with dfn test enabled' do
    let(:params) { {:use_dfn_test => true} }
    it do
      should contain_file('/etc/shibboleth/shibboleth2.xml') \
        .with_content(/<MetadataProvider type="XML" uri="https:\/\/www.aai.dfn.de\/fileadmin\/metadata\/DFN-AAI-Test-metadata.xml"/)
    end
  end

  context 'with custom metadata' do
    let(:params) { {:custom_metadata_url => 'https://foo.bar', :custom_metadata_signature_cert => 'puppet://my.file'} }
    it do
      should contain_file('/etc/shibboleth/shibboleth2.xml') \
        .with_content(/<MetadataProvider type="XML" uri="https:\/\/foo.bar"/)
      should contain_file('/etc/shibboleth/custom_metadata_signature.pem')
    end
  end

  context 'serve SP not at root but add a prefex to handler' do
    let(:params) { {:handlerurl_prefix => '/foobar' } }
    it do
      should contain_file('/etc/shibboleth/shibboleth2.xml') \
        .with_content(/handlerURL="\/foobar\/Shibboleth.sso">/)
    end
  end

  context 'with key' do
    let(:params) { {:key => 'keyfile' } }
    it do
      should contain_file('/etc/shibboleth/sp-key.pem').with({
        'ensure' => 'file',
        'owner'  => '_shibd',
        'group'  => 'root',
        'mode'   => '0400',
      })
    end
  end

  context 'with cert' do
    let(:params) { {
      :cert => 'puppet:///modules/dariahshibboleth/spec/sp-cert.pem',
      :hostname => 'foo.bar'
    } }
    it do
      should contain_file('/etc/shibboleth/sp-cert.pem').with({
        'ensure' => 'file',
        'owner'  => 'root',
        'group'  => 'root',
        'mode'   => '0644',
      })
      should contain_file('/opt/dariahshibboleth/sp-metadata.xml') \
        .with_content(/<ds:X509Certificate>\s*FooBar\s*<\/ds:X509Certificate>/) \
        .with_content(/entityID="https:\/\/foo.bar\/shibboleth">/) \
        .with_content(/<ds:KeyName>foo.bar<\/ds:KeyName>/)
    end
  end


  context 'with standby cert' do
    let(:params) { {
      :cert => 'puppet:///modules/dariahshibboleth/spec/sp-cert.pem',
      :standby_cert => 'puppet:///modules/dariahshibboleth/spec/sp-standby-cert.pem',
      :standby_key => 'puppet:///modules/dariahshibboleth/spec/sp-stanby-cert.pem',
      :hostname => 'foo.bar'
    } }
    it do
      should contain_file('/etc/shibboleth/sp-standby-cert.pem').with({
        'ensure' => 'file',
        'owner'  => 'root',
        'group'  => 'root',
        'mode'   => '0644',
      })
      should contain_file('/etc/shibboleth/sp-standby-key.pem').with({
        'ensure' => 'file',
        'owner'  => '_shibd',
        'group'  => 'root',
        'mode'   => '0400',
      })
      should contain_file('/opt/dariahshibboleth/sp-metadata.xml') \
        .with_content(/<ds:X509Certificate>\s*FooBar\s*<\/ds:X509Certificate>/) \
        .with_content(/<ds:X509Certificate>\s*Standby\s*<\/ds:X509Certificate>/) \
        .with_content(/<ds:KeyName>Active<\/ds:KeyName>/)
        .with_content(/<ds:KeyName>Standby<\/ds:KeyName>/)
    end    
  end

  context 'with changed REMOTE_USER preference' do
    let(:params) { {:remote_user_pref_list => 'foo bar' } }
    it do
      should contain_file('/etc/shibboleth/shibboleth2.xml') \
        .with_content(/REMOTE_USER="foo bar"/)
    end
  end

  context 'with https disabled' do
    let(:params) { {:handlerssl => false} }
    it do
      should contain_file('/etc/shibboleth/shibboleth2.xml') \
        .with_content(/handlerSSL="false" cookieProps="http"/)
    end
  end

  context 'with locallogout_headertags given' do
    let(:params) { {:locallogout_headertags => 'foobar'} }
    it do
      should contain_file('/etc/shibboleth/localLogout.html') \
        .with_content(/foobar/)
    end
  end

    it do
    should contain_service('shibd')
  end


end

