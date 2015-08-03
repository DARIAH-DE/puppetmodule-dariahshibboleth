require 'spec_helper'

describe "dariahshibboleth" do
  let(:facts) { {:osfamily => 'Debian', :lsbdistid => 'Ubuntu', :lsbdistcodename => 'trusty'} }

  it { should contain_class('dariahshibboleth::install')}
  it { should contain_class('dariahshibboleth::config')}
  it { should contain_class('dariahshibboleth::service')}
end

