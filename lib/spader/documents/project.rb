module Spader
  class Project < JsonDocument
    attr_accessor :title, :url, :author, :html, :js, :scss, :path
    
    def self.generate(base_dir, opts = {})
      project = Project.new()
      project.path = File.absolute_path(base_dir, Dir.pwd) + File::SEPARATOR
      project.title = opts.delete(:title) || "Example Title"
      project.url = opts.delete(:url) || "https://cosmicshovel.com/"
      project.author = opts.delete(:author) || "Cosmic Shovel, Inc."
      project.html = []
      project.js = []
      project.scss = []
      
      return project
    end
    
    def save_file(path)
      @document = {
        "path" => @path,
        "title" => @title,
        "url" => @url,
        "author" => @author,
        "html" => @html,
        "js" => @js,
        "scss" => @scss,
      }
      
      super
    end
  end
end