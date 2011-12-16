module NokogiriPList

  class Generator

    @generators = {}

    class << self

      def add(*klasses, &block)
        klasses.each do |klass|
          @generators[klass] = block
          klass.class_eval do
            def to_plist_xml(options = {})
              NokogiriPList::Generator.generate(self, nil, options)
            end
          end
        end
      end

      def build_xml(node, value)
        klass = @generators.keys.detect { |klass| value.is_a? klass }
        @generators[klass].call(self, node, value)
      end

      def create_child_element(node, name, contents = nil)
        create_element_args = contents ? [name, contents] : [name]
        child_element = node.document.create_element(*create_element_args)
        node.add_child(child_element)
      end

      def generate(value, node = nil, options={})
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
