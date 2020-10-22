module Spader
  require "spader/util"
  
  class JsonDocument
    @document = {}
    
    def load_file(path)
      @document = JSON.parse(read_file(path))
    end
    
    def save_file(path)
      write_file(path, JSON.pretty_generate(@document))
    end
  end
end