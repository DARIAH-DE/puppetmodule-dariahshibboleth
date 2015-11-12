require 'spec_helper'

describe "dariahshibboleth" do
  let(:facts) { {:osfamily => 'Debian', :lsbdistid => 'Ubuntu', :lsbdistcodename => 'trusty'} }

  it { should contain_anchor('dariahshibboleth::begin').that_comes_before('Class[dariahshibboleth::install]') }
  it { should contain_class('dariahshibboleth::install').that_comes_before('Class[dariahshibboleth::config]') }
  it { should contain_class('dariahshibboleth::config').that_notifies('Class[dariahshibboleth::service]') }
  it { should contain_class('dariahshibboleth::service').that_comes_before('Anchor[dariahshibboleth::end]') }
  it { should contain_class('dariahshibboleth::params') }
  it { should contain_anchor('dariahshibboleth::end') }

end

