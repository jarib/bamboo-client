# encoding: utf-8
$:.push File.expand_path("../lib", __FILE__)
require "bamboo-client/version"

Gem::Specification.new do |s|
  s.name        = "bamboo-client"
  s.version     = Bamboo::Client::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Jari Bakken"]
  s.email       = ["jari.bakken@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{Ruby client for Atlassian Bamboo's REST APIs}
  s.description = %q{Ruby client for Atlassian Bamboo's REST APIs}

  s.rubyforge_project = "bamboo-client"

  s.add_development_dependency "rspec"
  s.add_development_dependency "cucumber"

  s.add_dependency "rest-client"
  s.add_dependency "json"
  s.add_dependency "nokogiri"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
