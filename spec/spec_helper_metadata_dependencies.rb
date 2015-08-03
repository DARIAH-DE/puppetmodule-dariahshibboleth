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

