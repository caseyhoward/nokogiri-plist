begin
  require 'nokogiri'  
rescue LoadError
  require 'rubygems'
  retry
end
require 'date'

# TODO: Do this a not so stupid way
require File.join(File.dirname(__FILE__), 'string')
require File.join(File.dirname(__FILE__), 'nokogiri', 'plist', 'generator')
require File.join(File.dirname(__FILE__), 'nokogiri', 'plist', 'parser')
require File.join(File.dirname(__FILE__), 'nokogiri', 'plist')
require File.join(File.dirname(__FILE__), 'nokogiri', 'xml', 'node')