module Nokogiri

  class PList
      
    class Parser
      
      def parse(xml)
        @converters = {
          'integer' => Proc.new { |node| node.content.to_i },
          'real'    => Proc.new { |node| node.content.to_f },
          'string'  => Proc.new { |node| node.content.to_s },
          'date'    => Proc.new { |node| DateTime.parse(node.content) },
          'true'    => Proc.new { |node| true },
          'false'   => Proc.new { |node| false },
          'dict'    => Proc.new { |node| parse_dict node },
          'array'   => Proc.new { |node| parse_array node },
          'data'    => Proc.new { |node| node.content }
        }
        plist = xml.xpath('/plist').first
        parse_value_node next_valid_sibling(plist.children.first)
      end
      
      def parse_value_node(value_node)
        @converters[value_node.name].call(value_node)
      end
      
      def types
        @converters.keys
      end
      
      def valid_type?(type)
        not @converters[type].nil?
      end
      
      def valid_node?(node)
        valid_type?(node.name) or node.name == "key"
      end
      
      def parse_dict(node)
        node.xpath('./key').inject({}) do |return_value, key_node|
          return_value[key_node.content] = parse_value_node(next_valid_sibling key_node)
          return_value
        end
      end
      
      def parse_array(node)
        node.children.inject([]) do |return_value, node|
          return_value << parse_value_node(node) if valid_node? node
          return_value
        end
      end
      
      def next_valid_sibling(node)
        until node.nil? or valid_type? node.name
          node = node.next_sibling
        end
        node
      end
      
    end
    
  end
  
end