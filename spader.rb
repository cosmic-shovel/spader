# SPADER
# WebExtension maker's toolkit.
# Copyright (C) 2020 Cosmic Shovel, Inc.

require "rubygems"

require "date"
require "fileutils"
require "json"

require "sassc"
require "uglifier"

require_relative "spader/util"
require_relative "spader/zip"
require_relative "spader/skeleton"
require_relative "spader/build"
require_relative "spader/download"
#require_relative "rb/dl_libs"
#require_relative "rb/rendering_helpers"

########################################################################################

if ARGV.length() == 0 || ARGV.include?("--help") || ARGV.include?("-h")
  puts "ruby spader.rb <command> <args>\nvalid commands: skeleton, download, build\nvalid parameters:\n* skeleton: <project title>\n* download: none\n* build: <extension path> <browser> <environment> <version> [--zip]"
  exit(0)
end

spader_command = ARGV[0]

case spader_command
when "build"
  dmsg("Building...")
  build(ARGV[1].dup(), ARGV[2].dup(), ARGV[3].dup(), ARGV[4].dup(), ARGV.include?("--zip"))
when "download"
  dmsg("Downloading...")
  dmsg("Not implemented!")
when "skeleton"
  dmsg("Generating skeleton...")
  generate_skeleton(__dir__ + "/#{title.downcase().gsub(" ", "_")}/", title)
else
  dmsg("Invalid command, exiting.")
  exit(0)
end

exit(0)

zip_it = ARGV.include?("--zip")
dl_libs = ARGV.include?("--download-libs")
generate_skeleton = ARGV.include?("--skeleton")

if ARGV.length() < 3 && !dl_libs && !generate_skeleton
  dmsg("ruby spader.rb <browser> <environment> <version> [--zip]")
  dmsg("OR")
  dmsg("ruby spader.rb --download-libs")
  dmsg("OR")
  dmsg("ruby spader.rb --skeleton <extension name>")
  exit(0)
end

if generate_skeleton
  title = ARGV[1]
  
  if title.nil?()
    dmsg("ruby spader.rb --skeleton <extension name>")
    exit(0)
  end
  
  dmsg("Initializing extension: #{title}")
  generate_skeleton(__dir__ + "/#{title.downcase().gsub(" ", "_")}/", title)
  exit(0)
end

browser = ARGV[0]
environment = ARGV[1]
version = ARGV[2].dup()

browser_requires_polyfill = is_browser_chromal?(browser)
build_info = DateTime.now().strftime("%Y-%m-%d @ %H:%M:%S")
out_dir = "dist/#{environment}/#{browser}/"
camel_domain = "dissident.be"
api_endpoint = "dissident.be"
charts_domain = "charts-dev.camelcamelcamel.com"
#analytics_endpoint = "127.0.0.1:8787/"
analytics_endpoint = "hello.camelcamelcamel.com/camelizer"
zoom_levels = [0.25, 0.33, 0.5, 0.67, 0.75, 0.8, 0.9, 1.0, 1.1, 1.25, 1.5, 1.75, 2.0, 2.5, 3.0, 4.0, 5.0]

case browser
when "firefox"
  zoom_levels = [0.3, 0.5, 0.67, 0.8, 0.9, 1.0, 1.1, 1.2, 1.33, 1.5, 1.7, 2.0, 2.4, 3.0]
when "safari"
  zoom_levels = []
end

case environment
when "production"
  out_dir << "#{version}/"
  camel_domain = "camelcamelcamel.com"
  api_endpoint = "izer.camelcamelcamel.com"
  charts_domain = "charts.camelcamelcamel.com"
when "development"
  version << "000"
end

if dl_libs
  dl_libs(__dir__)
  exit(0)
end

required_domains = [
  "camelcamelcamel.com",
  "amazon.com",
  "amazon.co.uk",
  "amazon.fr",
  "amazon.de",
  "amazon.es",
  "amazon.ca",
  "amazon.it",
  "amazon.com.au",
  "camelizer.net",
  "camelizer.org",
]

html_templates = [
  "html/main.html.erb",
  "html/background.html.erb",
  "html/camel.html.erb",
  "html/options.html.erb",
]

js_templates = [
  "js/3camelizer.js.erb",
  "js/main.js.erb",
  "js/background.js.erb",
  "js/camel.js.erb",
  "js/options.js.erb",
  "js/content_script/announce.js.erb",
]

static_files = [
  "js/jquery/jquery-3.5.1.min.js",
  "js/foundation/foundation.js",
  "js/tooltipster/tooltipster.bundle.js",
  "js/util/what-input.js",
  "js/content_script/get_all_anchors.js",
  "js/content_script/set_firstrun_options.js",
  "js/introjs/intro.js",
  "txt/privacy.txt",
  "icon/icon-16.png",
  "icon/icon-32.png",
  "icon/icon-48.png",
  "icon/icon-64.png",
  "icon/icon-96.png",
  "icon/icon-128.png",
  "icon/icon-256.png",
  "icon/help-logo.png",
  "icon/gradient.png",
  "icon/chart_error.png",
  "font/fa-solid-900.woff2",
  "font/KFOmCnqEu92Fr1Mu7GxKOzY.woff2",
  "font/KFOmCnqEu92Fr1Mu4mxK.woff2"
]

if browser_requires_polyfill
  static_files << "js/browser/browser-polyfill.min.js"
end

translated_files = {
  "manifest/#{browser}.json" => "manifest.json",
  #"config/#{browser}.js" => "config.js",
  #"environment/#{environment}.js" => "environment.js",
}

dirs = [
]

case browser
when"firefox"
  translated_files["txt/links.txt"] = "amo-reviewer-links.txt"
end

SassC.load_paths << (__dir__ + "/scss/")
SassC.load_paths << (__dir__ + "/scss/foundation/")

dmsg("BUILDING #{browser}/#{environment} into #{out_dir}")

Dir.chdir(__dir__)

if Dir.exists?(out_dir)
  dmsg("  Removing old dirs")
  FileUtils.remove_dir(out_dir)
end

dmsg("  Ensuring dirs exist")
FileUtils.mkdir_p(out_dir)

dmsg("  Compiling SCSS")
Dir.chdir(__dir__ + "/scss/")
scss = SassC::Engine.new(read_file("3camelizer.scss"), style: :expanded).render()

Dir.chdir(__dir__)

dmsg("  Writing #{pretty_float(scss.length().to_f() / 1024.0)} KB to #{out_dir}/3camelizer.css")
write_file("#{out_dir}/3camelizer.css", scss)

if browser == "safari"
  Dir.chdir(__dir__ + "/scss/")
  scss = SassC::Engine.new(read_file("safari.scss"), style: :expanded).render()
  
  Dir.chdir(__dir__)
  
  dmsg("  Writing #{pretty_float(scss.length().to_f() / 1024.0)} KB to #{out_dir}/safari.css")
  write_file("#{out_dir}/safari.css", scss)
end

dmsg("  Rendering JS")
js_templates.each do |infile|
  outfile = out_dir + File.basename(infile, ".erb")
  dmsg("    Rendering #{infile} to #{outfile}")
  js = render(infile)
  dmsg("      Writing #{pretty_float(js.length().to_f() / 1024.0)} KB")
  write_file(outfile, js)
end

dmsg("  Rendering HTML...")
html_templates.each do |infile|
  outfile = out_dir + File.basename(infile, ".erb")
  dmsg("    Rendering #{infile} to #{outfile}")
  html = render(infile)
  dmsg("      Writing #{pretty_float(html.length().to_f() / 1024.0)} KB")
  write_file(outfile, html)
end

dmsg("  Copying files...")

static_files.each do |infile|
  outfile = out_dir + File.basename(infile)
  dmsg("    Copying #{infile} to #{outfile}")
  FileUtils.cp(infile, outfile)
end

translated_files.each do |infile,outfile|
  outpath = out_dir + outfile
  dmsg("    Copying #{infile} to #{outpath}")
  FileUtils.cp(infile, outpath)
end

dirs.each do |indir|
  Dir.entries(indir).each do |entry|
    if entry[0, 1] == "."
      next
    end
    
    dmsg("    Copying #{indir + "/" + entry} to #{out_dir + entry}")
    
    FileUtils.cp(indir + "/" + entry, out_dir + entry)
  end
end

dmsg("    Copying _locales to #{out_dir + "_locales"}")
FileUtils.cp_r("_locales", out_dir + "_locales")

dmsg("  Updating manifest.json")
manifest = JSON.parse(read_file(out_dir + "manifest.json"))
manifest["version"] = version

perms = [
  "activeTab",
  "storage",
 # "cookies",
 #"tabs",
]

if !is_browser_chromal?(browser)
  perms << "tabs"
end

required_domains.each do |dom|
  perms << "http://#{dom}/*"
  perms << "https://#{dom}/*"
  perms << "http://*.#{dom}/*"
  perms << "https://*.#{dom}/*"
end

manifest["permissions"] += perms

if environment == "development"
  manifest["permissions"] << "http://*.dissident.be/*"
  manifest["permissions"] << "http://dissident.be/*"
  manifest["permissions"] << "https://*.dissident.be/*"
  manifest["permissions"] << "https://dissident.be/*"
end

manifest["default_locale"] = "en"

manifest["options_ui"] = {
  "page" => "options.html",
}

write_file(out_dir + "manifest.json", JSON.pretty_generate(manifest))

if zip_it
  dmsg("  Creating zip archive...")
  zip_file = ZipFileGenerator.new(out_dir, "dist/3camelizer-#{browser}-#{environment}-#{version}.zip")
  zip_file.write()
end

dmsg("Build complete!")