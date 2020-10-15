def generate_skeleton(base_dir, title)
  if base_dir.nil?() || title.nil?()
    dmsg("Invalid parameters, exiting.")
    exit(0)
  end
  
  if base_dir[-1] != "/"
    base_dir = base_dir + "/"
  end
  
  conf = {
    "title" => title,
    "url" => "Sleve Mcdichael",
    "author" => "https://sleve.mcdichael/",
  }
  
  write_file(base_dir + "spader.conf", JSON.pretty_generate(conf))
  
  FileUtils.mkdir_p(base_dir + "_locales/en")
  
  messages = {
    "appName" => {
      "message" => title,
    },
    "appDesc" => {
      "message" => "This is a WebExtension project."
    }
  }
  
  write_file(base_dir + "_locales/en/messages.json", JSON.pretty_generate(messages))
  
  FileUtils.mkdir_p(base_dir + "dist/development")
  FileUtils.mkdir_p(base_dir + "dist/production")
  FileUtils.mkdir_p(base_dir + "font")
  FileUtils.mkdir_p(base_dir + "html")
  FileUtils.mkdir_p(base_dir + "icon")
  FileUtils.mkdir_p(base_dir + "js")
  FileUtils.mkdir_p(base_dir + "manifest")
  
  manifest = {
    "manifest_version" => 2,
    "name" => "__MSG_appName__",
    "short_name" => "__MSG_appName__",
    "description" => "__MSG_appDesc__",
    "default_locale" => "en",
    "version" => "0.0.1",
    "icons" => {
      "32" => "icon.png",
    },
    "author" => conf["author"],
    "homepage_url" => conf["url"],
    "permissions" => [
    ],
    
  }
  
  browsers().each do |browser|
    dup_manifest = manifest.dup()
    
    if browser == "chrome"
      dup_manifest["update_url"] = "http://clients2.google.com/service/update2/crx"
    end
    
    write_file(base_dir + "manifest/#{browser}.json", JSON.pretty_generate(dup_manifest))
  end
  
  FileUtils.mkdir_p(base_dir + "promo")
  FileUtils.mkdir_p(base_dir + "scss")
  FileUtils.mkdir_p(base_dir + "txt")
  FileUtils.touch(base_dir + "txt/README")
end