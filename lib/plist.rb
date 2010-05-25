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
      'date'    => Proc.new { |node| DateTime.strptime(node.content, "%Y-%m-%dT%H:%M:%SZ") },
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
      types.include? type
    end
    
    def self.valid_node?(node)
      valid_type?(node.name) or node.name == "key"
    end
    
    def self.filter_node(node)
      node.children.reject { |child| not valid_node?(child) }
    end
    
    def self.parse_dict(node)
      node.xpath('./key').inject({}) do |return_value, key_node|
        return_value.merge( { key_node.content => parse_value_node(next_valid_sibling key_node)} )
      end
    end
    
    def self.parse_array(node)
      filter_node(node).inject([]) do |return_value, node|
        return_value << parse_value_node(node)
      end
    end
    
    def self.next_valid_sibling(node, ignore_self=true)
      next_node = ignore_self ? node.next_sibling : node
      until next_node.nil? or PList::Parser.valid_type? next_node.name
        next_node = next_node.next_sibling
      end
      next_node
    end
    
  end
  
  
end