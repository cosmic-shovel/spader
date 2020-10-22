module Spader
  require "spader/util"
  
  class JsonDocument
    attr_accessor :document
    
    def initialize()
      @document = {}
    end
    
    def load_file(path)
      @document = JSON.parse(read_file(path))
    end
    
    def save_file(path)
      write_file(path, JSON.pretty_generate(@document))
    end
  end
  
  require "spader/documents/project"
  require "spader/documents/manifest"
end