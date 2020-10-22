Gem::Specification.new do |s|
  s.name = "spader"
  s.version = "0.0.0-pre"
  s.date = "2020-10-16"
  s.summary = "WebExtension maker's toolkit."
  s.description = "Spader provides a framework for building WebExtensions, making it easy to target multiple browsers."
  s.authors = ["Cosmic Shovel, Inc.", "Daniel Green"]
  s.email = "sup@cosmicshovel.com"
  s.homepage = "https://github.com/cosmic-shovel/spader"
  s.license = "MIT"
  s.platform = Gem::Platform::RUBY
  s.files = ["lib/spader.rb", "lib/spader/environment.rb", "lib/spader/json_document.rb"]
  s.executables << "spader"
end