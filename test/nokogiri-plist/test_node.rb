require 'test/test_helper'

class NokogiriPList::NodeTest < Test::Unit::TestCase

  context ".to_plist" do
    
    should "call parse on Nokogiri::PList::Parser with self" do
      @xml = Nokogiri::XML("<plist><string>a</string></plist>")
      NokogiriPList::Parser.expects(:parse).with(@xml).returns("a")
      @xml.to_plist
    end
    
  end
  
end
