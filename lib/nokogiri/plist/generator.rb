module Nokogiri

  module PList
    
    class Generator
      
      def self.indent_size
        2
      end
      
      def self.to_s(value, current_indent = 0)
        case value
          when Array
            tag("array", nil, current_indent) do
              value.inject("") do |result, item|             
                result + item.to_plist_xml_unchomped(current_indent + 1)
              end
            end
          when Hash
            tag("dict", nil, current_indent) do
              value.inject("") do |result, item| 
                result + tag("key", item[0], current_indent + 1).chomp +
                item[1].to_plist_xml_unchomped
              end
            end
          when TrueClass
            tag("true", nil, current_indent)
          when FalseClass
            tag("false", nil, current_indent)
          when Time
            tag("date", value.utc.strftime('%Y-%m-%dT%H:%M:%SZ'), current_indent)
          when Date # also catches DateTime
            tag("date", value.strftime('%Y-%m-%dT%H:%M:%SZ'), current_indent)
          when String, Symbol
            tag("string", value, current_indent)
          when Fixnum, Bignum, Integer
            tag("integer", value, current_indent)
          when Float
            tag("real", value, current_indent)
        end
      end
      
      def self.indent(number)
        " " * (number * indent_size) 
      end
      
      def self.array_or_hash?(item)
        item.is_a?(Hash) or item.is_a?(Array)
      end
      
      def self.tag(name, content=nil, current_indent=0, &block)
        return indent(current_indent) + "<#{name}/>\n" unless content or block_given?
        same_line = (["array", "dict"].include? name) ? false : true
        closing_tag_indent = same_line ? 0 : current_indent
        indent(current_indent) + "<#{name}>" + 
        (same_line ? "" : "\n") +
        if block_given?
          yield
        else
          content
        end.to_s +
        indent(closing_tag_indent) + "</#{name}>\n"
      end
    end
    
  end
  
end

[String, Symbol, Integer, Float, Date, Time, Hash, Array, TrueClass, FalseClass].each do |klass|
  
  klass.class_eval do

    def to_plist_xml(current_indent = 0)
      self.to_plist_xml_unchomped(current_indent).chomp
    end
    
    def to_plist_xml_unchomped(current_indent = 0)
      Nokogiri::PList::Generator.to_s(self, current_indent)
    end
    
  end

end
