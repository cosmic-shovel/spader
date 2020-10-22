require "spader/command"

module Spader
  class GenerateCommand < Command
    attr_accessor :path, :title
    
    def execute()
      super
      puts "Generating \"#{@title}\" into #{@path}"
      
      if @path.nil?() || @path.empty?() || @title.nil?() || @title.empty?()
        puts "Path and Title are required."
        raise InvalidParametersError
      end
      
      project = Project.generate(@path, :title => @title)
      
      if Dir.exists?(project.path)
        puts "Removing existing dir..."
        FileUtils.remove_dir(project.path)
      end
      
      FileUtils.mkdir_p(project.path)
      
      project.save_file(project.path + "spader.json")
    end
  end
end