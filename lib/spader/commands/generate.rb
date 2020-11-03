# encoding: UTF-8

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
      
      project.save_json(project.path + "spader.json")
      
      new_dirs = [
        "_locales/en",
        "font",
        "html",
        "icon",
        "js",
        "manifest",
        "promo",
        "scss",
        "txt",
      ]
      
      Spader::ENVIRONMENTS.each do |env|
        new_dirs << "dist/#{env}"
      end
      
      new_dirs.each do |new_dir|
        FileUtils.mkdir_p(project.path + new_dir)
      end
      
      FileUtils.touch(project.path + "txt/README.md")
      
      messages = Messages.generate(project.title)
      messages.save_json(project.path + "_locales/en/messages.json")
      
      manifest = Manifest.generate()
      
      #BROWSERS.each do |browser|
        #if browser == "chrome"
        #  manifest.document["update_url"] = "http://clients2.google.com/service/update2/crx"
        #else
        #  manifest.document.delete("update_url")
        #end
        
        manifest.save_json(project.path + "manifest/manifest.json.erb")
     # end
    end
  end
end