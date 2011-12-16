require 'bigdecimal'

module NokogiriPList

  class Generator

    @generators = {
      Array => Proc.new do |node, value|
        array_node = create_child_element(node, 'array')
        value.each do |value|
          generate(value, {}, array_node)
        end
      end,
      Hash => Proc.new do |node, value|
        dict_node = create_child_element(node, 'dict')
        value.each do |key, value|
          create_child_element(dict_node, "key", key)
          generate(value, {}, dict_node)
        end
      end,
      TrueClass  => Proc.new { |node, value| create_child_element(node, "true", {}) },
      FalseClass => Proc.new { |node, value| create_child_element(node, "false", {}) },
      Time       => Proc.new { |node, value| create_child_element(node, "date", value.utc.strftime('%Y-%m-%dT%H:%M:%SZ')) },
      Date       => Proc.new { |node, value| create_child_element(node, "date", value.strftime('%Y-%m-%dT%H:%M:%SZ')) }, # also catches DateTime
      String     => Proc.new { |node, value| create_child_element(node, "string", value) },
      Symbol     => Proc.new { |node, value| create_child_element(node, "string", value) },
      Fixnum     => Proc.new { |node, value| create_child_element(node, "integer", value) },
      Bignum     => Proc.new { |node, value| create_child_element(node, "integer", value) },
      Integer    => Proc.new { |node, value| create_child_element(node, "integer", value) },
      Float      => Proc.new { |node, value| create_child_element(node, "real", value) },
      BigDecimal => Proc.new { |node, value| create_child_element(node, "real", value.to_s('F')) }
    }

    @generators.keys.each do |klass|
      klass.class_eval do
        def to_plist_xml(options = {})
          NokogiriPList::Generator.generate(self, options)
        end
      end
    end

    class << self

      def build_xml(node, value)
        @generators.each do |klass, generator|
          if value.is_a? klass
            generator.call(node, value)
            break
          end
        end
      end

      def create_child_element(node, name, contents = nil)
        create_element_args = contents ? [name, contents] : [name]
        child_element = node.document.create_element(*create_element_args)
        node.add_child(child_element)
      end

      def generate(value, options={}, node = nil)
        if node
          build_xml(node, value)
        else
          document = options.delete(:fragment) ? build_fragment(value) : build_document(value)
          document.to_xml(options)
        end
      end

      def build_fragment(value)
        Nokogiri::XML::DocumentFragment.parse("").tap do |document|
          build_xml(document, value)
        end
      end

      def build_document(value)
        Nokogiri::XML::Document.new.tap do |document|
          document.create_internal_subset("plist", "-//Apple Computer//DTD PLIST 1.0//EN", "http://www.apple.com/DTDs/PropertyList-1.0.dtd")
          node = document.create_element("plist", :version => "1.0")
          document.add_child(node)
          build_xml(node, value)
        end
      end

    end

  end

end
