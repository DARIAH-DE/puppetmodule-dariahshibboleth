require 'spec_helper'

describe 'dariahshibboleth' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts.merge(networking: { 'fqdn' => 'fq.dn' })
      end

      it { is_expected.to contain_anchor('dariahshibboleth::begin').that_comes_before('Class[dariahshibboleth::install]') }
      it { is_expected.to contain_class('dariahshibboleth::install').that_comes_before('Class[dariahshibboleth::config]') }
      it { is_expected.to contain_class('dariahshibboleth::config').that_notifies('Class[dariahshibboleth::service]') }
      it { is_expected.to contain_class('dariahshibboleth::service').that_comes_before('Anchor[dariahshibboleth::end]') }
      it { is_expected.to contain_class('dariahshibboleth::params') }
      it { is_expected.to contain_anchor('dariahshibboleth::end') }

      it do
        is_expected.to contain_apt__source('SWITCHaai-swdistrib').with('location' => 'http://pkg.switch.ch/switchaai/ubuntu',
                                                                       'key' => {
                                                                         'id' => '294E37D154156E00FB96D7AA26C3C46915B76742',
                                                                         'source' => 'http://pkg.switch.ch/switchaai/SWITCHaai-swdistrib.asc',
                                                                       })
      end

      it do
        is_expected.to contain_package('shibboleth')
      end

      it do
        is_expected.to contain_file('/opt/dariahshibboleth') \
          .with_ensure('directory')
      end
      it do
        is_expected.to contain_file('/opt/dariahshibboleth/accessdenied.html')
      end

      context 'default settings' do
        it do
          is_expected.to contain_file('/etc/shibboleth/attribute-map.xml')
        end
        it do
          is_expected.to contain_file('/etc/shibboleth/attribute-policy.xml')
        end
        it do
          is_expected.to contain_file('/etc/shibboleth/attrChecker.html')
        end
        it do
          is_expected.to contain_file('/etc/shibboleth/dfn-aai.pem')
        end
        it do
          is_expected.to contain_file('/etc/shibboleth/dariah-proxy-idp.xml')
        end
        it do
          is_expected.to contain_file('/etc/shibboleth/localLogout.html')
        end
        it do
          is_expected.to contain_file('/etc/shibboleth/metadataError.html')
        end
        it do
          is_expected.to contain_file('/etc/shibboleth/sessionError.html')
        end
        it do
          is_expected.to contain_file('/etc/shibboleth/shibboleth2.xml') \
            .with_content(%r{handlerSSL="true" cookieProps="https"}) \
            .with_content(%r{<AttributeExtractor type="XML" validate="true" reloadChanges="false" path="attribute-map.xml"})
        end
      end

      context 'with hostname set' do
        let(:params) { { hostname: 'foobar' } }

        it do
          is_expected.to contain_file('/etc/shibboleth/shibboleth2.xml') \
            .with_content(%r{<ApplicationDefaults entityID="https:\/\/foobar\/shibboleth"})
        end
      end

      context 'with federation_enabled => true' do
        let(:params) { { federation_enabled: true, idp_entityid: 'foobar', discoveryurl: 'barfoo' } }

        it do
          is_expected.to contain_file('/etc/shibboleth/shibboleth2.xml') \
            .with_content(%r{<Handler type="AttributeChecker"}) \
            .with_content(%r{AttributeResolver type="SimpleAggregation"}) \
            .with_content(%r{sessionHook="\/Shibboleth.sso\/AttrChecker"}) \
            .with_content(%r{<SSO discoveryProtocol="SAMLDS" discoveryURL="barfoo">}) \
            .with_content(%r{flushSession="true"})
        end
      end

      context 'with federation_enabled => true and attribute_checker_flushsession => false' do
        let(:params) { { federation_enabled: true, attribute_checker_flushsession: false } }

        it do
          is_expected.to contain_file('/etc/shibboleth/shibboleth2.xml') \
            .with_content(%r{<Handler type="AttributeChecker"}) \
            .with_content(%r{flushSession="false"})
        end
      end

      context 'with attribute_checker enabled' do
        let(:params) { { disable_attribute_checker: false } }

        it do
          is_expected.to contain_file('/etc/shibboleth/shibboleth2.xml') \
            .with_content(%r{<Handler type="AttributeChecker"})
        end
      end

      context 'with attribute_checker disabled' do
        let(:params) { { disable_attribute_checker: true } }

        it do
          is_expected.to contain_file('/etc/shibboleth/shibboleth2.xml') \
            .without_content(%r{<Handler type="AttributeChecker"})
        end
      end

      context 'with federation_enabled => false' do
        let(:params) { { federation_enabled: false, idp_entityid: 'foobar' } }

        it do
          is_expected.to contain_file('/etc/shibboleth/shibboleth2.xml') \
            .with_content(%r{MetadataFilter type="Whitelist"}) \
            .with_content(%r{<SSO entityID="foobar">})
        end
      end

      context 'with dfn basic enabled' do
        let(:params) { { use_dfn_basic: true } }

        it do
          is_expected.to contain_file('/etc/shibboleth/shibboleth2.xml') \
            .with_content(%r{<MetadataProvider type="XML" uri="https:\/\/www.aai.dfn.de\/fileadmin\/metadata\/DFN-AAI-Basic-metadata.xml"})
        end
      end

      context 'with dfn test enabled' do
        let(:params) { { use_dfn_test: true } }

        it do
          is_expected.to contain_file('/etc/shibboleth/shibboleth2.xml') \
            .with_content(%r{<MetadataProvider type="XML" uri="https:\/\/www.aai.dfn.de\/fileadmin\/metadata\/DFN-AAI-Test-metadata.xml"})
        end
      end

      context 'with edugain via dfn' do
        let(:params) { { use_dfn_edugain: true } }

        it do
          is_expected.to contain_file('/etc/shibboleth/shibboleth2.xml') \
            .with_content(%r{<MetadataProvider type="XML" uri="https:\/\/www.aai.dfn.de\/fileadmin\/metadata\/DFN-AAI-eduGAIN\+idp-metadata.xml"})
        end
      end

      context 'with custom metadata' do
        let(:params) { { custom_metadata_url: 'https://foo.bar', custom_metadata_signature_cert: 'puppet://my.file' } }

        it do
          is_expected.to contain_file('/etc/shibboleth/shibboleth2.xml') \
            .with_content(%r{<MetadataProvider type="XML" uri="https:\/\/foo.bar"})
          is_expected.to contain_file('/etc/shibboleth/custom_metadata_signature.pem')
        end
      end

      context 'with proxy enabled' do
        let(:params) { { use_proxy: true, custom_metadata_signature_cert: 'puppet://my.file' } }

        it do
          is_expected.to contain_file('/etc/shibboleth/shibboleth2.xml') \
            .with_content(%r{<MetadataProvider type="XML" validate="true" file="dariah-proxy-idp.xml"\/>}) \
            .with_content(%r{<SSO entityID="https:\/\/aaiproxy.de.dariah.eu\/idp">})
        end
      end

      context 'serve SP not at root but add a prefex to handler' do
        let(:params) do
          {
            handlerurl_prefix: '/foobar',
            cert: 'puppet:///modules/dariahshibboleth/spec/sp-cert.pem',
          }
        end

        it do
          is_expected.to contain_file('/etc/shibboleth/shibboleth2.xml') \
            .with_content(%r{handlerURL="\/foobar\/Shibboleth.sso">})
          is_expected.to contain_file('/opt/dariahshibboleth/sp-metadata.xml') \
            .with_content(%r{\/foobar\/Shibboleth.sso\/SAML2\/POST}) \
            .with_content(%r{\/foobar\/Shibboleth.sso\/Login})
        end
      end

      context 'with key' do
        let(:params) { { key: 'keyfile' } }

        it do
          is_expected.to contain_file('/etc/shibboleth/sp-key.pem').with('ensure' => 'file',
                                                                         'owner'  => '_shibd',
                                                                         'group'  => 'root',
                                                                         'mode'   => '0400')
        end
      end

      context 'with cert' do
        let(:params) do
          {
            cert: 'puppet:///modules/dariahshibboleth/spec/sp-cert.pem',
            hostname: 'foo.bar',
          }
        end

        it do
          is_expected.to contain_file('/etc/shibboleth/sp-cert.pem').with('ensure' => 'file',
                                                                          'owner'  => 'root',
                                                                          'group'  => 'root',
                                                                          'mode'   => '0644')
          is_expected.to contain_file('/opt/dariahshibboleth/sp-metadata.xml') \
            .with_content(%r{<ds:X509Certificate>\s*FooBar\s*<\/ds:X509Certificate>}) \
            .with_content(%r{entityID="https:\/\/foo.bar\/shibboleth">}) \
            .with_content(%r{<ds:KeyName>foo.bar<\/ds:KeyName>})
        end
      end

      context 'with standby cert' do
        let(:params) do
          {
            cert: 'puppet:///modules/dariahshibboleth/spec/sp-cert.pem',
            standby_cert: 'puppet:///modules/dariahshibboleth/spec/sp-standby-cert.pem',
            standby_key: 'puppet:///modules/dariahshibboleth/spec/sp-stanby-cert.pem',
            hostname: 'foo.bar',
          }
        end

        it do
          is_expected.to contain_file('/etc/shibboleth/sp-standby-cert.pem').with('ensure' => 'file',
                                                                                  'owner'  => 'root',
                                                                                  'group'  => 'root',
                                                                                  'mode'   => '0644')
          is_expected.to contain_file('/etc/shibboleth/sp-standby-key.pem').with('ensure' => 'file',
                                                                                 'owner'  => '_shibd',
                                                                                 'group'  => 'root',
                                                                                 'mode'   => '0400')
          is_expected.to contain_file('/opt/dariahshibboleth/sp-metadata.xml') \
            .with_content(%r{<ds:X509Certificate>\s*FooBar\s*<\/ds:X509Certificate>}) \
            .with_content(%r{<ds:X509Certificate>\s*Standby\s*<\/ds:X509Certificate>}) \
            .with_content(%r{<ds:KeyName>Active<\/ds:KeyName>})
            .with_content(%r{<ds:KeyName>Standby<\/ds:KeyName>})
        end
      end

      context 'with custom list of required attributes' do
        let(:params) { { attribute_checker_requiredattributes: ['foobar'] } }

        it do
          is_expected.to contain_file('/etc/shibboleth/shibboleth2.xml') \
            .with_content(%r{<Rule require="foobar" })
        end
      end

      context 'with custom registration url' do
        let(:params) { { dariah_registration_url: 'https://boo.bar/register' } }

        it do
          is_expected.to contain_file('/etc/shibboleth/attrChecker.html') \
            .with_content(%r{<meta http-equiv="refresh" content="5; URL=https:\/\/boo.bar\/register%3Breturnurl%3D<shibmlp target\/>&entityID=<shibmlp entityID\/>"})
        end
      end

      context 'tou enforced' do
        it do
          is_expected.to contain_file('/etc/shibboleth/shibboleth2.xml') \
            .with_content(%r{<Rule require="dariahTermsOfUse">Terms_of_Use_germ_engl_v6.pdf<\/Rule>})
        end
      end

      context 'with additonal tous' do
        let(:params) do
          {
            tou_enforced: true,
            tou_sp_tou_group: 'foobargroup',
            tou_sp_tou_name: 'foobar.txt',
          }
        end

        it do
          is_expected.to contain_file('/etc/shibboleth/shibboleth2.xml') \
            .with_content(%r{<Rule require="dariahTermsOfUse">foobar.txt<\/Rule>})
          is_expected.to contain_file('/etc/shibboleth/attrChecker.html') \
            .with_content(%r{registration%3Binitialgroup%3Dfoobargroup%3Breturnurl%3D})
        end
      end

      context 'with changed REMOTE_USER preference' do
        let(:params) { { remote_user_pref_list: 'foo bar' } }

        it do
          is_expected.to contain_file('/etc/shibboleth/shibboleth2.xml') \
            .with_content(%r{REMOTE_USER="foo bar"})
        end
      end

      context 'with https disabled' do
        let(:params) { { handlerssl: false } }

        it do
          is_expected.to contain_file('/etc/shibboleth/shibboleth2.xml') \
            .with_content(%r{handlerSSL="false" cookieProps="http"})
        end
      end

      context 'with locallogout_headertags given' do
        let(:params) { { locallogout_headertags: 'foobar' } }

        it do
          is_expected.to contain_file('/etc/shibboleth/localLogout.html') \
            .with_content(%r{foobar})
        end
      end

      it do
        is_expected.to contain_service('shibd')
      end
    end
  end
end
