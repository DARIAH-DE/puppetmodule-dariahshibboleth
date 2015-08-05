require 'spec_helper'

describe "dariahshibboleth::service" do

  it do
    should contain_service('shibd')
  end
  


end

