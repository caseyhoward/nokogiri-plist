require 'test/test_helper'

class StringTest < Test::Unit::TestCase

  context ".to_plist" do

    should "calls PList parser with itself" do
      Nokogiri.expects(:PList).with("this is a test")

      "this is a test".to_plist
    end

  end

end
