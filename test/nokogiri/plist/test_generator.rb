require File.dirname(__FILE__) + '/../../test_helper'

class Nokogiri::PList::GeneratorTest < Test::Unit::TestCase
      
  context ".to_s" do
    
    context "Array" do
      
      should "print indented correctly" do
        assert_equal(
          "  <array>        <integer>1</integer>\n        <string>2</string>\n        <true/>\n        <real>0.3</real>\n  </array>\n",
          [1, "2", true, 0.3].to_plist_xml(2)
        )  
      end
      
    end
    
    context "Hash" do
      
      should "print indented correctly" do
        assert_equal(
          "  <dict>\n    <key>one</key><integer>1</integer>\n    <key>two</key><string>2</string>\n    <key>3</key><string>Three</string>\n  </dict>\n",
          { "one" => 1, :two => "2", 3 => "Three" }.to_plist_xml(2)
        )
      end
      
    end
    
  end

end
