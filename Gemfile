source 'https://rubygems.org'
 
group :development, :tests do
  gem 'rspec',                   :require => false
  gem 'rspec-core',              :require => false
  gem 'rspec-puppet',            :require => false
  gem 'puppetlabs_spec_helper',  :require => false
  gem 'simplecov',               :require => false
  gem 'puppet_facts',            :require => false
  gem 'json',                    :require => false
  gem 'metadata-json-lint',      :require => false
  gem 'puppet-syntax',           :require => false
  gem 'puppet-lint',             :require => false
  gem 'coveralls',               :require => false
end

group :system_tests do
  if beaker_version = ENV['BEAKER_VERSION']
    gem 'beaker', *location_for(beaker_version)
  end
  if beaker_rspec_version = ENV['BEAKER_RSPEC_VERSION']
    gem 'beaker-rspec', *location_for(beaker_rspec_version)
  else
    gem 'beaker-rspec',  :require => false
  end
  gem 'serverspec',    :require => false
  gem 'beaker-puppet_install_helper', :require => false
end

if puppetversion = ENV['PUPPET_GEM_VERSION']
  gem 'puppet', puppetversion, :require => false
else
  gem 'puppet', :require => false
end

