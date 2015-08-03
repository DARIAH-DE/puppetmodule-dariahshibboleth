require 'spec_helper_acceptance'

describe 'dariahshibboleth class' do
  it 'applies the module' do
    apply_manifest(%{
      class { 'dariahshibboleth': }
    }, :catch_failures => true)
  end

  describe package('shibboleth') do
    it { should be_installed }
  end
end

