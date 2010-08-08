require File.dirname(__FILE__) + '/../../test_helper'

class Nokogiri::PList::GeneratorTest < Test::Unit::TestCase
      
  context ".to_s" do    
    
    should "output arrays correctly" do
      xml_lines = [1, "2", true, 0.3].to_plist_xml(2).split(/\n/)
      assert_equal([
                    "    <array>",
                    "      <integer>1</integer>",
                    "      <string>2</string>",
                    "      <true/>",
                    "      <real>0.3</real>",
                    "    </array>"
                   ], xml_lines)
    end
    
    should "output hashs correctly" do
      xml_lines = { "one" => 1, :two => "2", 3 => "Three" }.to_plist_xml(2).split(/\n/)
      assert_equal("    <dict>", xml_lines[0])
      assert_same_elements([
          "      <key>one</key><integer>1</integer>",
          "      <key>two</key><string>2</string>",
          "      <key>3</key><string>Three</string>"       
        ],
        xml_lines[1..3]
      )
      assert_equal("    </dict>", xml_lines[4])
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
      assert_equal "    <false/>", false.to_plist_xml(2)
    end
    
  end

end
