$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "routesjs/rails/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "routesjs-rails"
  s.version     = RoutesJS::Rails::VERSION
  s.authors     = ["David Muto"]
  s.email       = ["david.muto@gmail.com"]
  s.homepage    = "https://github.com/pseudomuto/routesjs-rails"
  s.summary     = "Make named rails routes available in JS"
  s.description = "Make named rails routes available in JS"
  s.license     = "MIT"

  s.files = Dir["{lib,vendor/assets}/**/*", "LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["test/**/*"]

  s.required_ruby_version = ">= 1.9.3"
  s.add_dependency "rails", ">= 4.0", "< 5.0"
end
