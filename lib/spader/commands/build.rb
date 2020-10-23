module Spader
  class BuildCommand < Command
    attr_accessor :zip, :path, :browsers, :environment, :version
    
    def initialize()
      @path = nil
      @zip = false
      @environment = "development"
      @version = "0.0.0"
      @browsers = BROWSERS
    end
    
    def execute()
      super
      puts "Building #{@path} @ v#{@version}/#{@environment} for #{@browsers.length} browser(s)."
      
      if @path.nil?() || @path.empty?()
        puts "Path is required."
        raise InvalidParametersError
      end
      
      scss_dir = @path + "scss/"
      font_dir = @path + "font/"
      html_dir = @path + "html/"
      icon_dir = @path + "icon/"
      java_dir = @path + "js/"
      mani_dir = @path + "manifest/"
      msgs_dir = @path + "_locales/"
      
      SassC.load_paths << scss_dir
        
      dirs_in_dir(scss_dir).each do |dir|
        SassC.load_paths << dir
      end
      
      @browsers.each do |browser|
        dest_dir = @path + "dist/#{@environment}/#{browser}/"
        
        if environment == "production"
          dest_dir << "#{@version}/"
        end
        
        puts "Output dir: #{dest_dir}"
        
        if Dir.exists?(dest_dir)
          FileUtils.remove_dir(dest_dir)
        end
        
        FileUtils.mkdir_p(dest_dir)
      end
    end
  end
end