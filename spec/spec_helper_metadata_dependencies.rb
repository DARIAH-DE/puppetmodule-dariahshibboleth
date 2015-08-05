require 'json'

module RSpecPuppetDependencies
  
  def self.get_metadata
    if ! File.file?('metadata.json')
      fail StandardError, "No metadata.json!"
    end
    JSON.parse(File.read('metadata.json'))
  end

  def self.dependencies
    metadata = get_metadata

    if metadata['dependencies']
      metadata['dependencies']
    else
      nil
    end
  end

end

if ARGV[0] == 'install_to_fixtures' 
  RSpecPuppetDependencies.dependencies.each do |dependency|
    installcommand  = "puppet module install " + dependency['name'] + " -v '" + dependency['version_requirement'] + "' -i spec/fixtures/modules"
    puts installcommand
    system(installcommand)
  end 
end

