# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)
 
Gem::Specification.new do |s|
  s.name        = "nokogiri-plist"
  s.version     = '0.0.1'
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Casey Howard"]
  s.email       = ["caseyhoward@caseyhoward.com"]
  s.homepage    = "http://github.com/caseyhoward/nokogiri-plist"
  s.summary     = "The best way to manage your application's dependencies"
  s.description = "Bundler manages an application's dependencies through its entire life, across many machines, systematically and repeatably"
 
  s.required_rubygems_version = ">= 1.3.6"
  s.rubyforge_project         = "plist"
 
  s.add_development_dependency "rspec"
 
  s.files        = Dir.glob("{bin,lib}/**/*") + %w(LICENSE README.markdown)  
  s.require_path = 'lib'
end