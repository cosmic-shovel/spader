#require "spader/util"
#require "spader/zip"
#require "spader/skeleton"
#require "spader/build"
#require "spader/download"

require "spader/command"
require "spader/document"
  

module Spader
  BROWSERS = %w[chrome edge firefox opera safari].freeze()
  ENVIRONMENTS = %w[development production].freeze()
  
  require "date"
  require "fileutils"
  require "json"
  
  require "sassc"
  require "uglifier"
  
  require "optparse"
  
    def self.build(args)
      cmd = BuildCommand.new()
      
      OptionParser.new do |opts|
        opts.banner = "Usage: spader build <path> [options]"
        
        def opts.show_usage()
          puts self
          exit(1)
        end
        
        if args.empty?()
          opts.show_usage()
        end
        
        opts.on("-e", "--environment=ENVIRONMENT", "The target environment") do |env|
          if !ENVIRONMENTS.include?(env)
            opts.warn("Invalid environment specified")
            opts.show_usage()
          end
          
          cmd.environment = env
        end
        
        opts.on("-b", "--browsers=BROWSERS", "The target browser(s) in a comma-separated list") do |browsers|
          cmd.browsers = browsers.split(",")
        end
        
        opts.on("-v", "--version=VERSION", "The build version") do |version|
          cmd.version = version
        end
        
        opts.on("--zip", "Create a zip file of the build") do
          cmd.zip = true
        end
        
        begin
          opts.order(args) do |path|
            cmd.path = File.absolute_path(path, Dir.pwd)
            
            if cmd.path[-1, 1] != File::SEPARATOR
              cmd.path << File::SEPARATOR
            end
          end
        rescue OptionParser::ParseError => e
          opts.warn(e.message)
          opts.show_usage()
        end
      end
      
      cmd.execute()
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
        rescue OptionParser::ParseError => e
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