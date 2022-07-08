# encoding: UTF-8

module Spader
  class Project < Document
    attr_accessor :title, :url, :author, :html, :js, :scss, :path, :static, :permissions, :variables
    
    def self.generate(base_dir, opts = {})
      project = Project.new()
      project.title = opts.delete(:title) || "Example Title"
      project.url = opts.delete(:url) || "https://cosmicshovel.com/"
      project.author = opts.delete(:author) || "Cosmic Shovel, Inc."
      project.html = []
      project.js = []
      project.scss = []
      project.static = []
      project.permissions = []
      project.variables = {}
      
      return project
    end
    
    def save_json(path)
      @document = {
        "title" => @title,
        "url" => @url,
        "author" => @author,
        "html" => @html,
        "js" => @js,
        "scss" => @scss,
        "static" => @static,
        "permissions" => @permissions,
      }
      
      super
    end
    
    def load_json(path)
      super

      base_dir = File.dirname(path)
      
      @title = @document["title"]
      @url = @document["url"]
      @author = @document["author"]
      @html = absoluteize_paths(base_dir, @document["html"], "html")
      @js = absoluteize_paths(base_dir, @document["js"], "js")
      @scss = absoluteize_paths(base_dir, @document["scss"], "scss")
      @static = absoluteize_paths(base_dir, @document["static"], "static")
      @permissions = @document["permissions"]
      @variables = {}
      
      return self
    end

    def initialize_variables(browsers)
      browsers.each { |browser|
        @variables[browser] = {}
      }

      if @document.key?("variables")
        @document["variables"].each_pair do |key, value|
          browsers.each { |browser|
            if value.is_a?(Hash)
              @variables[browser][key] = value[browser]
            else
              @variables[browser][key] = value
            end
          }
        end
      end
    end
    
    private
    
    def absoluteize_paths(base_dir, paths, asset_type)
      out = []

      if asset_type != "static"
        base_dir = File.join(base_dir, asset_type)
      end
      
      paths.each do |path|
        out << File.absolute_path(File.join(base_dir, path))
      end
      
      return out
    end
  end
end