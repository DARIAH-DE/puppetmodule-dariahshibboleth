require 'spec_helper'

describe "dariahshibboleth::config" do

  context 'with federation_enabled => true' do
    let(:params) { {:federation_enabled => true} }
    it do
      should contain_file('/etc/shibboleth/shibboleth2.xml') \
        .with_content(/<Handler type="AttributeChecker"/) \
        .with_content(/AttributeResolver type="SimpleAggregation"/)
    end
  end

  context 'with federation_enabled => false' do
    let(:params) { {:federation_enabled => false} }
    it do
      should contain_file('/etc/shibboleth/shibboleth2.xml') \
        .with_content(/MetadataFilter type="Whitelist"/)
    end
  end

  context 'with dfn_metadata => Test' do
    let(:params) { {:dfn_metadata => 'Test'} }
    it do
      should contain_file('/etc/shibboleth/shibboleth2.xml') \
        .with_content(/<MetadataProvider type="XML" uri="https:\/\/www.aai.dfn.de\/fileadmin\/metadata\/DFN-AAI-Test-metadata.xml"/)
    end
  end
  
  context 'with dfn_metadata => Basic' do
    let(:params) { {:dfn_metadata => 'Basic'} }
    it do
      should contain_file('/etc/shibboleth/shibboleth2.xml') \
        .with_content(/<MetadataProvider type="XML" uri="https:\/\/www.aai.dfn.de\/fileadmin\/metadata\/DFN-AAI-Basic-metadata.xml"/)
    end
  end

end

