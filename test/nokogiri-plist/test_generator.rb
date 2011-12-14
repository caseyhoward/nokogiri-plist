require 'test/test_helper'

class NokogiriPList::GeneratorTest < Test::Unit::TestCase

  context "Array#to_plist_xml" do

    should "output plists correctly" do
      expected_xml = <<-XML
<?xml version="1.0"?>
<!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
  <array>
    <integer>1</integer>
    <string>2</string>
    <true/>
    <real>0.3</real>
  </array>
</plist>
      XML
      assert_equal(expected_xml, [1, "2", true, 0.3].to_plist_xml)
    end

    should "output plist fragments correctly" do
      expected_xml = <<-XML
<array>
  <integer>1</integer>
  <string>2</string>
  <true/>
  <real>0.3</real>
</array>
XML
      assert_equal(expected_xml.chomp, [1, "2", true, 0.3].to_plist_xml(:fragment => true))
    end

  end

  context "Hash#to_plist_xml" do

    should "output plists correctly" do
      xml_lines = { "one" => 1, :two => "2", 3 => "Three" }.to_plist_xml.split(/\n/)
      assert_equal("<?xml version=\"1.0\"?>", xml_lines[0])
      assert_equal("  <dict>", xml_lines[3])
      assert_same_elements([
          "    <key>one</key>",
          "    <integer>1</integer>",
          "    <key>two</key>",
          "    <string>2</string>",
          "    <key>3</key>",
          "    <string>Three</string>"
        ],
        xml_lines[4..9]
      )
      assert_equal("  </dict>", xml_lines[10])
    end

  end

  context "String#to_plist_xml" do

    should "output string plists correctly" do
      expected_xml = <<-XML
<?xml version="1.0"?>
<!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
  <string>a&amp;b</string>
</plist>
XML
      assert_equal expected_xml, "a&b".to_plist_xml
    end

    should "output plist fragments correctly" do
      expected_xml = "<string>a&amp;b</string>"
      assert_equal expected_xml, "a&b".to_plist_xml(:fragment => true)
    end

  end

  context "Integer#to_plist_xml" do

    should "output plists correctly" do
      expected_xml = <<-XML
<?xml version="1.0"?>
<!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
  <integer>123</integer>
</plist>
      XML
      assert_equal expected_xml, 123.to_plist_xml
    end

    should "output plist fragments correctly" do
      expected_xml = "<integer>123</integer>"
      assert_equal expected_xml, 123.to_plist_xml(:fragment => true)
    end

  end

  context "True#to_plist_xml" do

    should "output plists correctly" do
      expected_xml = <<-XML
<?xml version="1.0"?>
<!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
  <true/>
</plist>
      XML
      assert_equal expected_xml, true.to_plist_xml
    end

    should "output plist fragments correctly" do
      expected_xml = "<true/>"
      assert_equal expected_xml, true.to_plist_xml(:fragment => true)
    end

  end

  context "False#to_plist_xml" do

    should "output plists correctly" do
      expected_xml = <<-XML
<?xml version="1.0"?>
<!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
  <false/>
</plist>
      XML
      assert_equal expected_xml, false.to_plist_xml
    end

    should "output plist fragments correctly" do
      expected_xml = "<false/>"
      assert_equal expected_xml, false.to_plist_xml(:fragment => true)
    end

  end

  context "Time#to_plist_xml" do

    should "output plist correctly" do
      expected_xml = <<-XML
<?xml version="1.0"?>
<!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
  <date>2005-05-27T19:59:33Z</date>
</plist>
XML
      time = Time.local(2005, 5, 27, 12, 59, 33)
      assert_equal expected_xml, time.to_plist_xml
    end

    should "output plist fragments correctly" do
      expected_xml = "<date>2005-05-27T19:59:33Z</date>"
      time = Time.local(2005, 5, 27, 12, 59, 33)
      assert_equal expected_xml, time.to_plist_xml(:fragment => true)
    end

  end

  context "Decimal#to_plist_xml" do

    should "output decimal correctly" do
      require 'bigdecimal'
      expected_xml = <<-XML
<?xml version="1.0"?>
<!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
  <real>42.0</real>
</plist>
XML
      assert_equal expected_xml, BigDecimal.new("42").to_plist_xml
    end

    should "output plist fragments correctly" do
      require 'bigdecimal'
      expected_xml = "<real>42.0</real>"
      assert_equal expected_xml, BigDecimal.new("42").to_plist_xml(:fragment => true)
    end

  end

  should "build the document with Nokogiri and pass the options" do
    options = {}
    xml = mock()
    document = mock()
    document.expects(:to_xml).with(options).returns(xml)
    Nokogiri::XML::Builder.expects(:new).returns(document)
    assert_equal xml, [1, 2, 3].to_plist_xml(options)
  end

end
