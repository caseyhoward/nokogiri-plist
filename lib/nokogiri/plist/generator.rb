module Nokogiri

  module PList
    
    class Generator
      
      def self.indent_size
        2
      end
      
      def self.to_s(value, current_indent = 0)
        case value
          when Array
            indent(current_indent) + "<array>\n" +
            value.inject("") { |result, item| result + indent(current_indent) + item.to_plist_xml(current_indent + indent_size) + "\n" } +
            indent(current_indent) + "</array>"
          when Hash
            indent(current_indent) + "\n<dict>\n" +
            value.inject("") do |result, item| 
              result + 
              indent(current_indent) + "<key>#{item[0]}</key>" +
              item[1].to_plist_xml(current_indent + indent_size) + "\n"
            end +
            indent(current_indent) + "</dict>"
          when TrueClass, FalseClass
            indent(current_indent) + "<#{value}/>\n"
          when Time
            indent(current_indent) + "<date>#{value.utc.strftime('%Y-%m-%dT%H:%M:%SZ')}</date>\n"
          when Date # also catches DateTime
            indent(current_indent) + "<date>#{value.strftime('%Y-%m-%dT%H:%M:%SZ')}</date>\n"
          when String, Symbol
            indent(current_indent) + "<string>#{value}</string>"
          when Fixnum, Bignum, Integer
            indent(current_indent) + "<integer>#{value}</integer>"
          when Float
            indent(current_indent) + "<float>#{value}</float>"
        end
      end
      
      def self.indent(number)
        " " * number
      end
      
    end
    
  end
  
end

[String, Symbol, Integer, Float, Date, Time, Hash, Array, TrueClass, FalseClass].each do |klass|
  
  
  klass.class_eval do
    
    def to_plist_xml(current_indent = 0)
      Nokogiri::PList::Generator.to_s(self, current_indent)
    end
    
  end

end
