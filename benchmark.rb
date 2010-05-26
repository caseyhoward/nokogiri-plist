require 'benchmark'
require 'lib/nokogiri-plist'
require 'plist'

@large_tests = 2
@small_tests = 1000

Benchmark.bmbm do |x|
  x.report("nokoplist - large (#{@large_tests} tests)") { @large_tests.times { Nokogiri::XML(open 'spec/files/iTunes Music Library.xml').to_plist } }
  x.report("nokoplist - large (#{@large_tests} tests)") { @large_tests.times { Nokogiri::PList(open 'spec/files/iTunes Music Library.xml') } }
  x.report("plist -     large (#{@large_tests} tests)") { @large_tests.times { Plist::parse_xml('spec/files/iTunes Music Library.xml') } }

  x.report("nokoplist - small (#{@small_tests} tests)") { @small_tests.times { Nokogiri::XML(open 'spec/files/itunes.xml').to_plist } }
  x.report("nokoplist - small (#{@small_tests} tests)") { @small_tests.times { Nokogiri::PList(open 'spec/files/itunes.xml') } }
  x.report("plist -     small (#{@small_tests} tests)") { @small_tests.times { Plist::parse_xml('spec/files/itunes.xml')  } }
end