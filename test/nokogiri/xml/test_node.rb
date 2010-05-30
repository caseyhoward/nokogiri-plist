require File.dirname(__FILE__) + '/../../test_helper'

class Nokogiri::XML::NodeTest < Test::Unit::TestCase

  context ".to_plist" do
    
    should "call parse on Nokogiri::PList::Parser with self" do
      @xml = Nokogiri::XML("<plist><string>a</string></plist>")
      Nokogiri::PList::Parser.expects(:parse).with(@xml).returns("a")
      @xml.to_plist
    end
    
  end
  
end
