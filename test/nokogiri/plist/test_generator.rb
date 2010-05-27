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
#       
#       def self.to_s(value, current_indent = 0, do_indent = true)
#         case value
#           when Array
#             "\n" + indent(current_indent, true) + "<array>" +
#             value.inject("") do |result, item| 
#               result + 
#               indent(current_indent + indent_size, true) + 
#               item.to_plist_xml(current_indent + indent_size, true)
#             end + "\n" +
#             indent(current_indent, true) + "</array>"
#           when Hash
#             "\n" + indent(current_indent) + "<dict>\n" +
#             value.inject("") do |result, item| 
#               result +
#               indent(current_indent + indent_size, true) + "<key>#{item[0]}</key>" +
#               item[1].to_plist_xml(current_indent + indent_size, false)
#             end + "\n" +
#             indent(current_indent, true) + "</dict>"
#           when TrueClass, FalseClass
#             indent(current_indent, do_indent) + "<#{value}/>\n"
#           when Time
#             indent(current_indent, do_indent) + "<date>#{value.utc.strftime('%Y-%m-%dT%H:%M:%SZ')}</date>\n"
#           when Date # also catches DateTime
#             indent(current_indent, do_indent) + "<date>#{value.strftime('%Y-%m-%dT%H:%M:%SZ')}</date>\n"
#           when String, Symbol
#             indent(current_indent, do_indent) + "<string>#{value}</string>\n"
#           when Fixnum, Bignum, Integer
#             indent(current_indent, do_indent) + "<integer>#{value}</integer>\n"
#           when Float
#             indent(current_indent, do_indent) + "<float>#{value}</float>\n"
#         end
#       end
#       
#       def self.indent(number, do_indent = true)
#         do_indent ? " " * number : "" 
#       end
#       
#     end
#     
#   end
#   
# end
# 