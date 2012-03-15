# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "redmine/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "ruby-redmine_client"
  s.version     = Redmine::VERSION
  s.authors     = ["Patrick Helm"]
  s.email       = ["deradon87@gmail.com"]
  s.homepage    = "https://github.com/Deradon/Ruby-Redmine_client"
  s.summary     = "Client to access Redmine information"
  s.description = "Client to access Redmine information"

  s.executables   = ["redmine"]
  s.files         = Dir["{bin,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files    = Dir["{test,spec,features}/**/*"]
  s.require_paths = ["lib"]

  s.add_dependency "nokogiri"
  s.add_development_dependency "rspec", "~> 2.6"
end

