module Spader
  class Project < Document
    attr_accessor :title, :url, :author, :html, :js, :scss, :path, :static, :permissions
    
    def self.generate(base_dir, opts = {})
      project = Project.new()
      project.path = make_path_absolute(base_dir, Dir.pwd, :dir)
      project.title = opts.delete(:title) || "Example Title"
      project.url = opts.delete(:url) || "https://cosmicshovel.com/"
      project.author = opts.delete(:author) || "Cosmic Shovel, Inc."
      project.html = []
      project.js = []
      project.scss = []
      project.static = []
      project.permissions = []
      
      return project
    end
    
    def save_json(path)
      @document = {
        "path" => @path,
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
      
      @path = @document["path"]
      @title = @document["title"]
      @url = @document["url"]
      @author = @document["author"]
      @html = absoluteize_paths(@document["html"], "html")
      @js = absoluteize_paths(@document["js"], "js")
      @scss = absoluteize_paths(@document["scss"], "scss")
      @static = absoluteize_paths(@document["static"], "static")
      @permissions = @document["permissions"]
      
      return self
    end
    
    private
    
    def absoluteize_paths(paths, asset_type)
      out = []
      
      base_dir = @path.dup()
      
      if asset_type != "static"
        base_dir << asset_type + File::SEPARATOR
      end
      
      paths.each do |path|
        out << make_path_absolute(path, base_dir, :file)
      end
      
      return out
    end
  end
end