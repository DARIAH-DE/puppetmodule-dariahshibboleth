require 'spec_helper'

describe "dariahshibboleth" do
  it { should contain_class('dariahshibboleth::install')}
  it { should contain_class('dariahshibboleth::config')}
  it { should contain_class('dariahshibboleth::metadata')}
end

