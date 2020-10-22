#require "spader/util"
#require "spader/zip"
#require "spader/skeleton"
#require "spader/build"
#require "spader/download"

require "spader/command"
  require "spader/json_document"
  require "spader/project"

module Spader
  require "date"
  require "fileutils"
  require "json"
  
  require "sassc"
  require "uglifier"
  
  require "optparse"
  
    def self.build(args)
      cmd = BuildCommand.new(args)
    end
    
    def self.generate(args)
      cmd = GenerateCommand.new()
      
      OptionParser.new do |opts|
        opts.banner = "Usage: spader generate <path>"
        
        def opts.show_usage()
          puts self
          exit(1)
        end
        
        if args.empty?()
          opts.show_usage()
        end
        
        begin
          opts.order(args) do |path|
            cmd.path = File.absolute_path(path, Dir.pwd)
            
            if cmd.path[-1, 1] != File::SEPARATOR
              cmd.path << File::SEPARATOR
            end
          end
        rescue OptionParser::ParserError => e
          opts.warn(e.message)
          opts.show_usage()
        end
      end
      
      while cmd.title.nil?() || cmd.title.empty?() do
        puts "What is the name of your extension?"
        cmd.title = STDIN.gets().chomp()
      end
      
      cmd.execute()
    end
end