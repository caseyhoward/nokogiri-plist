require File.dirname(__FILE__) + '/../../test_helper'

class Nokogiri::PList::GeneratorTest < Test::Unit::TestCase
      
  context ".to_s" do    
      
    should "output arrays correctly" do
      assert_equal(
        "    <array>\n      <integer>1</integer>\n      <string>2</string>\n      <true/>\n      <real>0.3</real>\n    </array>",
        [1, "2", true, 0.3].to_plist_xml(2)
      )  
    end
    
    should "output hashs correctly" do
      assert_equal(
        "    <dict>\n      <key>one</key><integer>1</integer>\n      <key>two</key><string>2</string>\n      <key>3</key><string>Three</string>\n    </dict>",
        { "one" => 1, :two => "2", 3 => "Three" }.to_plist_xml(2)
      )
    end
      
    should "output strings correctly" do
      assert_equal "<string>test</string>", "test".to_plist_xml
      assert_equal "    <string>test</string>", "test".to_plist_xml(2)
    end
    
    should "output integers correctly" do
      assert_equal "<integer>123</integer>", 123.to_plist_xml
      assert_equal "    <integer>234</integer>", 234.to_plist_xml(2)
    end
    
    should "output true correctly" do
      assert_equal "<true/>", true.to_plist_xml
      assert_equal "    <true/>", true.to_plist_xml(2)
    end
    
    should "output false correctly" do
      assert_equal "<false/>", false.to_plist_xml
      # assert_equal "    <false/>", false.to_plist_xml(:indent => { :spaces => 2 })
      assert_equal "    <false/>", false.to_plist_xml(2)
    end
    
  end

end
