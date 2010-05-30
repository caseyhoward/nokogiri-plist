# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)
 
Gem::Specification.new do |s|
  s.name        = "nokogiri-plist"
  s.version     = '0.2.0'
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Casey Howard"]
  s.email       = ["caseyhoward@caseyhoward.com"]
  s.homepage    = "http://github.com/caseyhoward/nokogiri-plist"
  s.summary     = "PList parsing capabilities built using Nokogiri"
  s.description = "Allows Nokogiri objects to be converted to PLists"
 
  s.required_rubygems_version = ">= 1.3.6"
  s.rubyforge_project         = "nokogiri-plist"
 
  s.add_development_dependency ""
 
  s.files        = Dir.glob("{lib, test}/**/*") + %w(LICENSE README.rdoc)  
  s.require_paths = ['lib']
end
