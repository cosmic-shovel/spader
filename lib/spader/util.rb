def write_file(filename, data, append = false)
  if data.is_a?(String)
    data = data.force_encoding(Encoding::UTF_8)
  end
  
  begin
    File.open(filename, append ? "a" : "w") { |f|
      f.write(data)
    }
  rescue Exception => e
    dmsg(e)
  end
end

def read_file(filename)
  begin
    File.open(filename, "r") do |f|
      return f.readlines().join("")
    end
  rescue Exception => e
    dmsg(e)
  end

  return nil
end

# eventually this should use a special Spader binding
# and allow users to expose their own variables
def render(template)
  browser = $spader_cmd.browser
  build_info = $spader_cmd.build_info
  camel_domain = "dissident.be"
  api_endpoint = "dissident.be"
  charts_domain = "charts-dev.camelcamelcamel.com"
  analytics_endpoint = "hello.camelcamelcamel.com/camelizer"
  browser_requires_polyfill = is_browser_chromal?()
  zoom_levels = [0.25, 0.33, 0.5, 0.67, 0.75, 0.8, 0.9, 1.0, 1.1, 1.25, 1.5, 1.75, 2.0, 2.5, 3.0, 4.0, 5.0]
  b = binding
  template = File.absolute_path(template, $spader_cmd.path)
  
  return ERB.new(read_file(template)).result(b)
end

def pad10(str_num)
  return "%02d" % [str_num.to_i()]
end

def dmsg(msg, cache = false)
  t = DateTime.now()
  msg = msg.is_a?(String) ? msg : msg.inspect()
  
  puts "[#{pad10(t.hour())}:#{pad10(t.min())}:#{pad10(t.sec())}] " + msg
end

def pretty_float(f)
  return ("%0.2f" % f) 
end

def is_camelizer_three_oh_oh?(ver)
  return Gem::Version.new(ver) == Gem::Version.new("3.0.0")
end

def anchor_target()
  if !is_browser_chromal?()
    return ""
  end
  
  return "target=\"_blank\""
end

def is_browser_chromal?()
  return %w[chrome edge opera brave].include?($spader_cmd.browser.downcase())
end

def browsers()
  return Spader::BROWSERS
end

def entries(path)
  list = Dir.entries(path).delete_if {|f| f == "." || f == ".."}
  out = []
  
  list.each do |entry|
    full_path = path.dup()
    
    if path[-1, 1] != "/"
      full_path << "/"
    end
    
    full_path << entry
    out << full_path
  end
  
  return out
end

def dirs_in_dir(path)
  list = entries(path).delete_if {|f| !File.directory?(f)}
  out = []
  
  list.each do |entry|
    if entry[-1, 1] != "/"
      entry << "/"
    end
    
    out << entry
  end
  
  return out
end

def files_in_dir(path)
  list = entries(path).delete_if {|f| File.directory?(f)}
  
  return list
end

def primary_files_in_dir(path)
  return files_in_dir(path).delete_if {|f| File.basename(f)[0, 1] == "_"}
end

def partial_files_in_dir(path)
  return files_in_dir(path).delete_if {|f| File.basename(f)[0, 1] != "_"}
end

def primary_scss_files()
  
end

def primary_js_files()
  
end

def primary_html_files()
  
end