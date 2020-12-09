Gem::Specification.new do |s|
  s.name = "spader"
  s.version = "0.0.4-pre"
  s.date = "2020-12-08"
  s.summary = "WebExtension maker's toolkit."
  s.description = "Spader provides a framework for building WebExtensions, making it easy to target multiple browsers."
  s.authors = ["Cosmic Shovel, Inc."]
  s.email = "sup@cosmicshovel.com"
  s.homepage = "https://github.com/cosmic-shovel/spader"
  s.license = "MIT"
  s.platform = Gem::Platform::RUBY
  s.files = [
    "lib/spader.rb",
    "lib/spader/util.rb",
    "lib/spader/zip.rb",
    "lib/spader/command.rb",
    "lib/spader/commands/build.rb",
    "lib/spader/commands/generate.rb",
    "lib/spader/document.rb",
    "lib/spader/documents/manifest.rb",
    "lib/spader/documents/messages.rb",
    "lib/spader/documents/project.rb",
  ]
  s.executables << "spader"
  s.add_runtime_dependency "sassc", "~> 2.4"
  s.add_runtime_dependency "zip-zip", "~> 0.3"
  s.add_runtime_dependency "uglifier", "~> 4.2"
end