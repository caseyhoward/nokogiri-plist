require 'bigdecimal'

module NokogiriPList

  class Generator

    @generators = {
      Array => Proc.new do |xml, value|
        xml.array do
          value.each do |value|
            value.to_plist_xml({}, xml)
          end
        end
      end,
      Hash => Proc.new do |xml, value|
        xml.dict do
          value.each do |key, value|
            xml.key key
            value.to_plist_xml({}, xml)
          end
        end
      end,
      TrueClass  => Proc.new { |xml, value| xml.true },
      FalseClass => Proc.new { |xml, value| xml.false },
      Time       => Proc.new { |xml, value| xml.date value.utc.strftime('%Y-%m-%dT%H:%M:%SZ') },
      Date       => Proc.new { |xml, value| xml.date value.strftime('%Y-%m-%dT%H:%M:%SZ') }, # also catches DateTime
      String     => Proc.new { |xml, value| xml.string value },
      Symbol     => Proc.new { |xml, value| xml.string value },
      Fixnum     => Proc.new { |xml, value| xml.integer value },
      Bignum     => Proc.new { |xml, value| xml.integer value },
      Integer    => Proc.new { |xml, value| xml.integer value },
      Float      => Proc.new { |xml, value| xml.real value },
      BigDecimal => Proc.new { |xml, value| xml.real value.to_s('F') }
    }

    def self.to_xml(value, xml)
      @generators.each do |klass, generator|
        if value.is_a? klass
          generator.call(xml, value)
          break
        end
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
        is_fragment = options.delete(:fragment)
        document_class = is_fragment ? Nokogiri::XML::DocumentFragment : Nokogiri::XML::Document
        document = document_class.parse("")
        Nokogiri::XML::Builder.with(document) do |xml|
          if is_fragment
            NokogiriPList::Generator.to_xml(self, xml)
          else
            add_doctype_to_document(xml.doc)
            xml.plist(:version => "1.0") do |xml|
              NokogiriPList::Generator.to_xml(self, xml)
            end
          end
        end
        document.to_xml(options)
      end
    end

    def add_doctype_to_document(document)
      document.create_internal_subset("plist", "-//Apple Computer//DTD PLIST 1.0//EN", "http://www.apple.com/DTDs/PropertyList-1.0.dtd")
    end

  end

end
