require 'bigdecimal'

module NokogiriPList

  class Generator

    def self.inspect
      'NokogiriPList::Generator'
    end

    def self.indent_size
      2
    end

    def self.to_s(value, current_indent = 0)
      # Todo: make these procs and allow custom procs (for data for example)
      case value
      when Array
        tag("array", nil, current_indent) do
          result = ''
          value.each do |item|
            result << item.to_plist_xml_unchomped(current_indent + 1)
          end
          result
        end
      when Hash
        tag("dict", nil, current_indent) do
          result = ''
          value.each do |dict_key, dict_value|
            result << tag('key', dict_key, current_indent + 1).chomp
            result << dict_value.to_plist_xml_unchomped
          end
          result
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
      when BigDecimal
        tag("real", value.to_s('F'), current_indent)
      end
    end

    def self.indent(number)
      " " * (number * indent_size)
    end

    def self.array_or_hash?(item)
      item.is_a?(Hash) or item.is_a?(Array)
    end

    def self.tag(name, content=nil, current_indent=0, &block)
      if content or block_given?
        new_line = (["array", "dict"].include? name) ? "\n" : ""
        closing_tag_indent = (new_line != "\n") ? 0 : current_indent
        indent(current_indent) + "<#{name}>" + new_line +
        (block_given? ? yield : CGI.escapeHTML(content.to_s)).to_s +
        indent(closing_tag_indent) + "</#{name}>\n"
      else
        indent(current_indent) + "<#{name}/>\n"
      end
    end
  end

end


[String, Symbol, Integer, Float, BigDecimal, Date, Time, Hash, Array, TrueClass, FalseClass].each do |klass|
  klass.class_eval do

    def to_plist_xml(current_indent = 0)
      self.to_plist_xml_unchomped(current_indent).chomp
    end

    def to_plist_xml_unchomped(current_indent = 0)
      NokogiriPList::Generator.to_s(self, current_indent)
    end

  end

end
