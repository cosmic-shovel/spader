#require "spader/commands/build"
#require "spader/commands/download"

module Spader
  class Command
    class InvalidParametersError < StandardError; end;
      
    def execute()
      puts "RUNNING #{self.class}"
    end
  end
  
  require "spader/commands/generate"
  require "spader/commands/build"
end