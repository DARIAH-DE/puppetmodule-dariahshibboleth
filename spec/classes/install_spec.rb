require 'spec_helper'

describe "dariahshibboleth::install" do
  let(:facts) { {:osfamily => 'Debian', :lsbdistid => 'Ubuntu', :lsbdistcodename => 'trusty'} }

  it do
    should contain_package('shibboleth')
  end
  


end

