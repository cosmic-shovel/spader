# encoding: UTF-8

require "ostruct"
require_relative "zip"

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
  version = $spader_cmd.version
  build_info = $spader_cmd.build_info
  vars = $spader_cmd.variables
  vars.merge!({ "browser" => browser, "version" => version, "build_info" => build_info})
  b = OpenStruct.new(vars).instance_eval { binding }
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
  return files_in_dir(path).delete_if {|f| bn = File.basename(f); bn[0, 1] == "_" || bn[0, 1] == "."}
end

def partial_files_in_dir(path)
  return files_in_dir(path).delete_if {|f| bn = File.basename(f); bn[0, 1] != "_"}
end

def primary_scss_files()

end

def primary_js_files()

end

def primary_html_files()

end

# path_type = one of [:dir, :file]
def make_path_absolute(path, base_dir, path_type)
  tmp = File.absolute_path(path, base_dir)

  if path_type == :dir
    if tmp[-1, 1] != File::SEPARATOR
      tmp << File::SEPARATOR
    end
  end

  return tmp
end