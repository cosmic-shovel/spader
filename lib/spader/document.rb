module Spader
  require "spader/util"
  
  class Document
    attr_accessor :document
    
    def initialize()
      @document = {}
    end
    
    def load_json(path)
      @document = JSON.parse(read_file(path))
    end
    
    def save_json(path)
      write_file(path, JSON.pretty_generate(@document))
    end
  end
  
  require "spader/documents/project"
  require "spader/documents/manifest"
  require "spader/documents/messages"
end