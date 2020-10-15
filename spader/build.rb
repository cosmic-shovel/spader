def build(base_dir, browser, environment, version, zip = false)
  if base_dir.nil?() || browser.nil?() || environment.nil?() || version.nil?()
    dmsg("Invalid build parameters, exiting.")
    exit(0)
  end
  
  if base_dir[0, 1] != "/" && base_dir[1, 1] != ":"
    base_dir = Dir.getwd() + "/" + base_dir
  end
  
  if base_dir[-1, 1] != "/"
    base_dir << "/"
  end
  
  scss_dir = base_dir + "scss/"
  font_dir = base_dir + "font/"
  html_dir = base_dir + "html/"
  icon_dir = base_dir + "icon/"
  java_dir = base_dir + "js/"
  mani_dir = base_dir + "manifest/"
  tran_dir = base_dir + "_locales/"
  dist_dir = base_dir + "dist/#{environment}/#{browser}/"
  
  case environment
  when "development"
    
  when "production"
    dist_dir << "#{version}/"
  else
    throw "Unsupported environment: #{environment}"
  end
  
  if Dir.exists?(dist_dir)
    FileUtils.remove_dir(dist_dir)
  end
  
  FileUtils.mkdir_p(dist_dir)
  
  # config stuff now that we have our paths
  SassC.load_paths << scss_dir
  
  dirs_in_dir(scss_dir).each do |dir|
    SassC.load_paths << dir
  end
  
  ### start building
  
  # manifest
  in_manifest_file = mani_dir + "#{browser}.json"
  out_manifest_file = dist_dir + "manifest.json"
  FileUtils.cp(in_manifest_file, out_manifest_file)
  
  # translation strings
  FileUtils.cp_r(tran_dir, dist_dir + "_locales")
  
  # (s)css(.erb) files
  root_scss_files = files_in_dir(scss_dir).delete_if {|f| f[0, 1] == "_"}
  
  root_scss_files.each do |scss_file|
    in_fn = File.basename(scss_file)
    out_file = dist_dir + in_fn
    
    if scss_file.include?(".erb")
      # render file to scss + parse scss
      scss_data = render(scss_file)
      scss_data = SassC::Engine.new(scss_data, style: :expanded).render()
      write_file(out_file, scss_data)
    elsif scss_file.include?(".css")
      FileUtils.cp(scss_file, out_file)
    elsif scss_file.include?(".scss")
      scss_data = SassC::Engine.new(read_file(scss_file), style: :expanded).render()
      write_file(out_file, scss_data)
    else
      dmsg("Unsupported file type (skipping): #{scss_file}")
    end
  end
  
  # .js(.erb) files
  root_js_files = files_in_dir(java_dir).delete_if {|f| f[0, 1] == "_"}
  
  root_js_files.each do |js_file|
    in_fn = File.basename(js_file)
    out_file = dist_dir + in_fn
    
    if js_file.include?(".js.erb")
      js_data = render(js_file)
      write_file(out_file, js_data)
    elsif js_file.include?(".js")
      FileUtils.cp(js_file, out_file)
    else
      dmsg("Unsupported file type (skipping): #{js_file}")
    end
  end
  
  # .html(.erb) files
  root_html_files = files_in_dir(html_dir).delete_if {|f| f[0, 1] == "_"}
  
  root_html_files.each do |html_file|
    in_fn = File.basename(html_file)
    out_file = dist_dir + in_fn
    
    if html_file.include?(".html.erb")
      html_data = render(html_file)
      write_file(out_file, html_data)
    elsif html_file.include?(".htm")
      FileUtils.cp(html_file, out_file)
    else
      dmsg("Unsupported file type (skipping): #{html_file}")
    end
  end
end