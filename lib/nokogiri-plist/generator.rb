require 'bigdecimal'

module NokogiriPList

  class Generator

    def self.to_xml(value, xml)
      case value
      when Array
        xml.array do
          value.each do |value|
            value.to_plist_xml(0, xml)
          end
        end
      when Hash
        xml.dict do
          value.each do |dict_key, dict_value|
            xml.key dict_key
            dict_value.to_plist_xml(0, xml)
          end
        end
      when TrueClass
        xml.true
      when FalseClass
        xml.false
      when Time
      when Date # also catches DateTime
      when String, Symbol
        xml.string value
      when Fixnum, Bignum, Integer
        xml.integer value
      when Float
        xml.real value
      when BigDecimal
        xml.real value.to_s('F')
      end

    end
  end
end

[String, Symbol, Integer, Float, BigDecimal, Date, Time, Hash, Array, TrueClass, FalseClass].each do |klass|
  klass.class_eval do

    def to_plist_xml(options = {}, xml = nil)
      if xml
        NokogiriPList::Generator.to_xml(self, xml)
      else
        builder = Nokogiri::XML::Builder.new do |xml|
          NokogiriPList::Generator.to_xml(self, xml)
        end
        xml = builder.to_xml(options)
        xml.sub!(/^[^\n]*\n/, "")
        xml.chomp!
        xml
      end
    end

  end

end
