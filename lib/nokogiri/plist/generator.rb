module Nokogiri

  module PList
    
    class Generator
      
      def self.indent_size
        2
      end
      
      def self.to_s(value, current_indent = 0, do_indent = true)
        case value
          when Array
            "\n" + indent(current_indent, true) + "<array>" +
            value.inject("") do |result, item| 
              result + 
              indent(current_indent + indent_size, true) + 
              item.to_plist_xml(current_indent + indent_size, true)
            end + "\n" +
            indent(current_indent, true) + "</array>"
          when Hash
            "\n" + indent(current_indent) + "<dict>\n" +
            value.inject("") do |result, item| 
              result +
              indent(current_indent + indent_size, true) + "<key>#{item[0]}</key>" +
              item[1].to_plist_xml(current_indent + indent_size, false)
            end + "\n" +
            indent(current_indent, true) + "</dict>"
          when TrueClass, FalseClass
            indent(current_indent, do_indent) + "<#{value}/>\n"
          when Time
            indent(current_indent, do_indent) + "<date>#{value.utc.strftime('%Y-%m-%dT%H:%M:%SZ')}</date>\n"
          when Date # also catches DateTime
            indent(current_indent, do_indent) + "<date>#{value.strftime('%Y-%m-%dT%H:%M:%SZ')}</date>\n"
          when String, Symbol
            indent(current_indent, do_indent) + "<string>#{value}</string>\n"
          when Fixnum, Bignum, Integer
            indent(current_indent, do_indent) + "<integer>#{value}</integer>\n"
          when Float
            indent(current_indent, do_indent) + "<float>#{value}</float>\n"
        end
      end
      
      def self.indent(number, do_indent = true)
        do_indent ? " " * number : "" 
      end
      
    end
    
  end
  
end

[String, Symbol, Integer, Float, Date, Time, Hash, Array, TrueClass, FalseClass].each do |klass|
  
  
  klass.class_eval do
    
    def to_plist_xml(current_indent = 0, do_indent = true)
      Nokogiri::PList::Generator.to_s(self, current_indent, do_indent)
    end
    
  end

end
