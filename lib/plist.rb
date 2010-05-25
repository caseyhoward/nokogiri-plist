require 'rubygems'
require 'nokogiri'
require 'date'

module PList
  
  class Parser
    class << self 
      attr_reader :converters
    end

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
     
    def self.parse(file_name)
      plist = Nokogiri::XML(open(file_name)).xpath('/plist').first
      parse_value_node filter_node(plist).first
    end
    
    def self.parse_value_node(value_node)
      converters[value_node.name].call(value_node)
    end
    
    def self.types
      converters.keys
    end
    
    def self.valid_type?(type)
      not converters[type].nil?
    end
    
    def self.valid_node?(node)
      valid_type?(node.name) or node.name == "key"
    end
    
    def self.filter_node(node)
      node.children.reject { |child| not valid_node?(child) }
    end
    
    def self.parse_dict(node)
      node.xpath('./key').inject({}) do |return_value, key_node|
        return_value[key_node.content] = parse_value_node(next_valid_sibling key_node)
        return_value
      end
    end
    
    def self.parse_array(node)
      filter_node(node).inject([]) do |return_value, node|
        return_value << parse_value_node(node)
      end
    end
    
    def self.next_valid_sibling(node)
      until node.nil? or PList::Parser.valid_type? node.name
        node = node.next_sibling
      end
      node
    end
    
  end
  
  
end