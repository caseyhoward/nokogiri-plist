load_path = File.expand_path(File.dirname(__FILE__))
$LOAD_PATH.unshift(load_path) unless $LOAD_PATH.include?(load_path)

begin
  require 'nokogiri'
rescue LoadError
  require 'rubygems'
  retry
end
require 'date'
require 'cgi'

require 'nokogiri-plist/generator'
require 'nokogiri-plist/parser'
require 'nokogiri-plist/node'
require 'nokogiri-plist/plist'

require 'core_ext/string'

Nokogiri::XML::Node.send :include, NokogiriPList::Node
