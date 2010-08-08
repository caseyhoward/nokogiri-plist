require File.dirname(__FILE__) + '/../../test_helper'

class Nokogiri::PList::ParserTest < Test::Unit::TestCase

  should "parse plists with plist tags" do
    assert_equal 3, Nokogiri::PList("<plist><integer>3</integer></plist>")
    assert_equal 3.14, Nokogiri::PList("<plist><real>3.14</real></plist>")
    assert_equal "blah", Nokogiri::PList("<plist><string>blah</string></plist>")
    assert_equal [1, "2", true, 0.3], Nokogiri::PList("<plist><array><integer>1</integer><string>2</string><true/><real>0.3</real></array></plist>")
    assert_equal 3, Nokogiri::PList("<plist><integer>3</integer></plist>")
  end

  should "parse plists with plist tags" do
    assert_equal 3, Nokogiri::PList("<integer>3</integer>")
    assert_equal 3.14, Nokogiri::PList("<real>3.14</real>")
    assert_equal "blah", Nokogiri::PList("<string>blah</string>")
    assert_equal [1, "2", true, 0.3], Nokogiri::PList("<array> <integer>1</integer> <string>2</string> <true/> <real>0.3</real> </array>")
    assert_equal 3, Nokogiri::PList("<integer>3<f/integer>")
  end
    
end