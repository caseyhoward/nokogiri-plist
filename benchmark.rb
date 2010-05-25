require 'benchmark'
require 'lib/plist'
require 'plist'

Benchmark.bmbm do |x|
  x.report("nokoplist - large") { PList::Parser.parse('spec/files/iTunes Music Library.xml') }
  x.report("nokogiri -  large") { Nokogiri::XML(open('spec/files/iTunes Music Library.xml')) }
  x.report("plist -     large") { Plist::parse_xml('spec/files/iTunes Music Library.xml') }

  x.report("nokoplist - small") { 100.times { PList::Parser.parse('spec/files/itunes.xml') } }
  x.report("nokogiri -  small") { 100.times { Nokogiri::XML.parse(open('spec/files/itunes.xml')) } }
  x.report("plist -     small") { 100.times { Plist::parse_xml('spec/files/itunes.xml')  } }
end