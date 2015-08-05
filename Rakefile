require 'rake'
require 'rspec/core/rake_task'
require 'puppetlabs_spec_helper/rake_tasks'
require 'puppetlabs_spec_helper/module_spec_helper'
require 'puppetlabs_spec_helper/puppetlabs_spec_helper'
require 'puppet-lint/tasks/puppet-lint'
require 'puppet-syntax/tasks/puppet-syntax'
require 'metadata-json-lint/rake_task'

Rake::Task[:lint].clear

PuppetLint.configuration.relative = true
PuppetLint.configuration.with_filename = true
PuppetLint.configuration.send("disable_80chars")
PuppetLint.configuration.log_format = "%{path}:%{linenumber}:%{check}:%{KIND}:%{message}"
PuppetLint.configuration.fail_on_warnings = true

PuppetLint.configuration.send('disable_class_parameter_defaults')
PuppetLint.configuration.send('disable_class_inherits_from_params_class')

exclude_paths = [
  "bundle/**/*",
  "pkg/**/*",
  "vendor/**/*",
  "spec/**/*",
]
PuppetLint.configuration.ignore_paths = exclude_paths
PuppetSyntax.exclude_paths = exclude_paths

desc "Run acceptance tests"
RSpec::Core::RakeTask.new(:acceptance) do |t|
  t.pattern = 'spec/acceptance'
end

desc "Populate CONTRIBUTORS file"
task :contributors do
  system("git log --format='%aN' | sort -u > CONTRIBUTORS")
end

desc "Run metadata_lint, syntax, lint, and unit tests."
task :test => [
  :metadata_lint,
  :syntax,
  :lint,
  :unit,
]

task :default => :help

desc "Run unit tests"
task :unit do
  Rake::Task["spec_prep"].invoke
  system("ruby spec/spec_helper_metadata_dependencies.rb install_to_fixtures")
  Rake::Task["spec_standalone"].invoke
end

desc "Clean after unit tests"
task :unit_clean do
  Rake::Task["spec_clean"].invoke
  system("rm -r spec/fixtures/*")
end

Rake::Task["coverage"].clear
Rake::Task["metadata"].clear
Rake::Task["spec"].clear
Rake::Task["spec_clean"].clear
#Rake::Task["spec_prep"].clear
