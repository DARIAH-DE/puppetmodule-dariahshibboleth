require 'spec_helper'

describe "dariahshibboleth::install" do
  let(:facts) { {:osfamily => 'Debian', :lsbdistid => 'Ubuntu', :lsbdistcodename => 'trusty'} }

  context 'debian wheezy system' do
    let(:facts) { {:osfamily => 'Debian', :lsbdistid => 'Debian', :lsbdistcodename => 'wheezy'} }
    it do
      should contain_apt__source('SWITCHaai-swdistrib').with({
        'location' => 'http://pkg.switch.ch/switchaai/debian',
        'key'      => '294E37D154156E00FB96D7AA26C3C46915B76742',
      })
    end
  end

  context 'ubuntu trusty system' do
    let(:facts) { {:osfamily => 'Debian', :lsbdistid => 'Ubuntu', :lsbdistcodename => 'trusty'} }
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


end

