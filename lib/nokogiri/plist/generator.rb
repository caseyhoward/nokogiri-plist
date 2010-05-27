module Nokogiri

  module PList
    
    class Generator
      
      def self.indent_size
        2
      end
      
      def self.to_s(value, current_indent = 0, do_indent=true)
        case value
          when Array
            indent(current_indent) + "<array>\n" +
            value.inject("") do |result, item|  
              newline = array_or_hash?(item) ? "\n" : ""
              indent = current_indent + indent_size           # array_or_hash?(item) ? 0 : current_indent + indent_size              
              result + item.to_plist_xml_unchomped(indent)
            end +
            indent(current_indent) + "</array>\n"
          when Hash
            indent(current_indent) + "<dict>\n" +
            value.inject("") do |result, item| 
              newline = array_or_hash?(item[1]) ? "\n" : ""
              result +
              indent(current_indent + indent_size) + "<key>#{item[0]}</key>" +
              newline +
              item[1].to_plist_xml_unchomped(current_indent + indent_size, false)
            end +
            indent(current_indent) + "</dict>\n"
          when TrueClass, FalseClass
            indent(current_indent, do_indent) + "<#{value}/>\n"
          when Time
            indent(current_indent) + "<date>#{value.utc.strftime('%Y-%m-%dT%H:%M:%SZ')}</date>\n"
          when Date # also catches DateTime
            indent(current_indent, do_indent) + "<date>#{value.strftime('%Y-%m-%dT%H:%M:%SZ')}</date>\n"
          when String, Symbol
            indent(current_indent, do_indent) + "<string>#{value}</string>\n"
          when Fixnum, Bignum, Integer
            indent(current_indent, do_indent) + "<integer>#{value}</integer>\n"
          when Float
            indent(current_indent, do_indent) + "<real>#{value}</real>\n"
        end
      end
      
      def self.indent(number, do_indent=true)
        do_indent ? " " * number : "" 
      end
      
      def self.array_or_hash?(item)
        item.is_a?(Hash) or item.is_a?(Array)
      end
    end
    
  end
  
end

[String, Symbol, Integer, Float, Date, Time, Hash, Array, TrueClass, FalseClass].each do |klass|
  
  klass.class_eval do

    def to_plist_xml(current_indent = 0, do_indent=true)
      self.to_plist_xml_unchomped(current_indent, do_indent).chomp
    end
    
    def to_plist_xml_unchomped(current_indent = 0, do_indent=true)
      Nokogiri::PList::Generator.to_s(self, current_indent, do_indent)
    end
    
  end

end
