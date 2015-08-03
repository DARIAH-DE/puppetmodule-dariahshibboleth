require 'beaker-rspec'
require 'beaker/puppet_install_helper'
require 'spec_helper_metadata_dependencies'

hosts.each do |host|
  # Install Puppet
  on host, install_puppet
end

RSpec.configure do |c|
  module_root = File.expand_path(File.join(File.dirname(__FILE__), '..'))

  c.formatter = :documentation

  # Configure all nodes in nodeset
  c.before :suite do
    # Install module
    puppet_module_install(:source => module_root, :module_name => 'dariahshibboleth')
    hosts.each do |host|
      # install dependencies as defined in metadata
      RSpecPuppetDependencies.dependencies.each do |dependency|
        on host, puppet('module', 'install', dependency['name'], dependency['version_requirement']), { :acceptable_exit_codes => [0,1] }
      end 
    end
  end
end

