require 'spec_helper'

describe "dariahshibboleth::install" do

  it do
    should contain_package('shibboleth')
  end
  


end

