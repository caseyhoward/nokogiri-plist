require 'test/test_helper'

class NokogiriPList::GeneratorTest < Test::Unit::TestCase

  context ".to_plist_xml" do

    should "output arrays correctly" do
      xml_lines = [1, "2", true, 0.3].to_plist_xml.split(/\n/)
      assert_equal([
                    "<array>",
                    "  <integer>1</integer>",
                    "  <string>2</string>",
                    "  <true/>",
                    "  <real>0.3</real>",
                    "</array>"
                   ], xml_lines)
    end

    should "output hashs correctly" do
      xml_lines = { "one" => 1, :two => "2", 3 => "Three" }.to_plist_xml.split(/\n/)
      assert_equal("<dict>", xml_lines[0])
      assert_same_elements([
          "  <key>one</key><integer>1</integer>",
          "  <key>two</key><string>2</string>",
          "  <key>3</key><string>Three</string>"
        ],
        xml_lines[1..3]
      )
      assert_equal("</dict>", xml_lines[4])
    end

    should "output strings correctly" do
      assert_equal "<string>a&amp;b</string>", "a&b".to_plist_xml
    end

    should "output integers correctly" do
      assert_equal "<integer>123</integer>", 123.to_plist_xml
    end

    should "output true correctly" do
      assert_equal "<true/>", true.to_plist_xml
    end

    should "output false correctly" do
      assert_equal "<false/>", false.to_plist_xml
    end

    should "output decimal correctly" do
      require 'bigdecimal'
      assert_equal "<real>42.0</real>", BigDecimal.new("42").to_plist_xml
    end

    should "build the document with Nokogiri and pass the options" do
      options = mock()
      builder = mock()
      xml = "<?xml version=\"1.0\"?>\n<test/>"
      builder.expects(:to_xml).with(options).returns(xml)
      Nokogiri::XML::Builder.expects(:new).returns(builder)
      assert_equal "<test/>", [1, 2, 3].to_plist_xml(options)
    end

  end

end
