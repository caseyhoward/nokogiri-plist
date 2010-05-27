require File.dirname(__FILE__) + '/../../test_helper'

class Nokogiri::XML::NodeTest < Test::Unit::TestCase
  
  context ".to_plist" do
    
    should "call PList::Parser.new with itself" do
      @node = Nokogiri::XML("<test></test>").xpath('/test').first
      Nokogiri::PList::Parser.expects(:new).with(@node)
      @node.to_plist
    end
    
  end
  
end