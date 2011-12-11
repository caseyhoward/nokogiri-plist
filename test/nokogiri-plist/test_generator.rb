require 'test/test_helper'

class NokogiriPList::GeneratorTest < Test::Unit::TestCase

  context ".to_plist_xml" do

    should "output arrays correctly" do
      xml_lines = [1, "2", true, 0.3].to_plist_xml.split(/\n/)
      assert_equal([
                    "<?xml version=\"1.0\"?>",
                    "<array>",
                    "  <integer>1</integer>",
                    "  <string>2</string>",
                    "  <true/>",
                    "  <real>0.3</real>",
                    "</array>"
                   ], xml_lines)
    end

    should "output hashs correctly" do
      debugger
      xml_lines = { "one" => 1, :two => "2", 3 => "Three" }.to_plist_xml.split(/\n/)
      assert_equal("<?xml version=\"1.0\"?>", xml_lines[0])
      assert_equal("<dict>", xml_lines[1])
      assert_same_elements([
          "  <key>one</key>",
          "  <integer>1</integer>",
          "  <key>two</key>",
          "  <string>2</string>",
          "  <key>3</key>",
          "  <string>Three</string>"
        ],
        xml_lines[2..7]
      )
      assert_equal("</dict>", xml_lines[8])
    end

    should "output strings correctly" do
      assert_equal "<?xml version=\"1.0\"?>\n<string>a&amp;b</string>\n", "a&b".to_plist_xml
    end

    should "output integers correctly" do
      assert_equal "<?xml version=\"1.0\"?>\n<integer>123</integer>\n", 123.to_plist_xml
    end

    should "output true correctly" do
      assert_equal "<?xml version=\"1.0\"?>\n<true/>\n", true.to_plist_xml
    end

    should "output false correctly" do
      assert_equal "<?xml version=\"1.0\"?>\n<false/>\n", false.to_plist_xml
    end

    should "output times correctly" do
      time = Time.local(2005, 5, 27, 12, 59, 33)
      assert_equal "<?xml version=\"1.0\"?>\n<date>2005-05-27T19:59:33Z</date>\n", time.to_plist_xml
    end

    should "output decimal correctly" do
      require 'bigdecimal'
      assert_equal "<?xml version=\"1.0\"?>\n<real>42.0</real>\n", BigDecimal.new("42").to_plist_xml
    end

    should "build the document with Nokogiri and pass the options" do
      options = mock()
      builder = mock()
      xml = "<?xml version=\"1.0\"?>\n<test/>"
      builder.expects(:to_xml).with(options).returns(xml)
      Nokogiri::XML::Builder.expects(:new).returns(builder)
      assert_equal "<?xml version=\"1.0\"?>\n<test/>", [1, 2, 3].to_plist_xml(options)
    end

  end

end
