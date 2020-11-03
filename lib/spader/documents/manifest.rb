# encoding: UTF-8

module Spader
  class Manifest < Document
    def self.generate()
      manifest = Manifest.new()
      
      manifest.document = {
        "manifest_version" => 2,
        "name" => "__MSG_appName__",
        "short_name" => "__MSG_appName__",
        "description" => "__MSG_appDesc__",
        "default_locale" => "en",
        "version" => "0.0.1",
        "icons" => {
          "32" => "icon.png",
        },
        "author" => "Sleve Mcdichael",
        "homepage_url" => "https://cosmicshovel.com/",
        "permissions" => [
        ],
      }
      
      return manifest
    end
  end
end