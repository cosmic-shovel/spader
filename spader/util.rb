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

def render(template)
  return ERB.new(read_file(template)).result()
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

def is_browser_chromal?(b)
  return %w[chrome edge opera brave].include?(b.downcase())
end

def browsers()
  return %w[chrome firefox safari opera edge]
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