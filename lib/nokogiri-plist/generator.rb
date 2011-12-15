require 'bigdecimal'
require 'singleton'

module NokogiriPList

  class Generator
    include Singleton

    attr_reader :generators

    def initialize
      @generators = {
        Array => Proc.new do |xml, value|
          xml.array do
            value.each do |value|
              generate(value, {}, xml)
            end
          end
        end,
        Hash => Proc.new do |xml, value|
          xml.dict do
            value.each do |key, value|
              xml.key key
              generate(value, {}, xml)
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

      @generators.keys.each do |klass|
        klass.class_eval do
          def to_plist_xml(options = {})
            NokogiriPList::Generator.instance.generate(self, options)
          end
        end
      end

    end

    def build_xml(value, xml)
      @generators.each do |klass, generator|
        if value.is_a? klass
          generator.call(xml, value)
          break
        end
      end
    end

    def generate(value, options, xml=nil)
      if xml
        build_xml(value, xml)
      else
        document = options.delete(:fragment) ? build_fragment(value) : build_document(value)
        document.to_xml(options)
      end
    end

    def build_fragment(value)
      Nokogiri::XML::DocumentFragment.parse("").tap do |document|
        Nokogiri::XML::Builder.with(document) do |xml|
          build_xml(value, xml)
        end
      end
    end

    def build_document(value)
      Nokogiri::XML::Builder.new do |xml|
        xml.doc.create_internal_subset("plist", "-//Apple Computer//DTD PLIST 1.0//EN", "http://www.apple.com/DTDs/PropertyList-1.0.dtd")
        xml.plist(:version => "1.0") do |xml|
          build_xml(value, xml)
        end
      end
    end

  end

end

NokogiriPList::Generator.instance # Initialize the singleton instance
