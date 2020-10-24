module Spader
  class BuildCommand < Command
    attr_accessor :zip, :path, :browsers, :browser, :environment, :version, :build_info
    
    def initialize()
      @path = nil
      @zip = false
      @environment = "development"
      @version = "0.0.0"
      @browsers = BROWSERS
      @browser = nil
      @build_info = nil
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
      
      @build_info = DateTime.now().strftime("%Y-%m-%d @ %H:%M:%S")
      
      @browsers.each do |browser|
        @browser = browser
        dest_dir = @path + "dist/#{@environment}/#{browser}/"
        
        if environment == "production"
          dest_dir << "#{@version}/"
        end
        
        puts "Output dir: #{dest_dir}"
        
        if Dir.exists?(dest_dir)
          FileUtils.remove_dir(dest_dir)
        end
        
        FileUtils.mkdir_p(dest_dir)
        
        # manifest
        in_manifest = mani_dir + "#{browser}.json"
        out_manifest = dest_dir + "manifest.json"
        FileUtils.cp(in_manifest, out_manifest)
        
        # messages
        FileUtils.cp_r(msgs_dir, dest_dir + "_locales")
        
        scss_files = primary_files_in_dir(scss_dir)
        
        scss_files.each do |scss_file|
          puts scss_file
          in_filename = File.basename(scss_file)
          out_file = dest_dir + in_filename.gsub(".erb", "").gsub(".css", "").gsub(".scss", "")
          out_file << ".css"
          scss_data = nil
          
          if in_filename.include?(".erb")
            scss_data = render(scss_file)
          else
            scss_data = read_file(scss_file) 
          end
          
          scss_data = SassC::Engine.new(scss_data, :style => :expanded).render()
          write_file(out_file, scss_data)
        end
        
        js_files = primary_files_in_dir(java_dir)
        
        js_files.each do |js_file|
          puts js_file
          in_filename = File.basename(js_file)
          out_file = dest_dir + in_filename.gsub(".erb", "").gsub(".js", "")
          out_file << ".js"
          js_data = nil
          
          if in_filename.include?(".erb")
            js_data = render(js_file)
          else
            js_data = read_file(js_file)
          end
          
          write_file(out_file, js_data)
        end
        
        html_files = primary_files_in_dir(html_dir)
        
        html_files.each do |html_file|
          puts html_file
          in_filename = File.basename(html_file)
          out_file = dest_dir + in_filename.gsub(".erb", "").gsub(".html", "")
          out_file << ".html"
          html_data = nil
          
          if in_filename.include?(".erb")
            html_data = render(html_file)
          else
            html_data = read_file(html_data)
          end
          
          write_file(out_file, html_data)
        end
      end
    end
  end
end