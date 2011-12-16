require 'bigdecimal'

NokogiriPList::Generator.add(Array) do |generator, node, value|
  array_node = generator.create_child_element(node, 'array')
  value.each do |value|
    generator.generate(value, array_node)
  end
end

NokogiriPList::Generator.add(Hash) do |generator, node, value|
  dict_node = generator.create_child_element(node, 'dict')
  value.each do |key, value|
    generator.create_child_element(dict_node, "key", key)
    generator.generate(value, dict_node)
  end
end

NokogiriPList::Generator.add(TrueClass) do |generator, node, value|
  generator.create_child_element(node, "true")
end

NokogiriPList::Generator.add(FalseClass) do |generator, node, value|
  generator.create_child_element(node, "false")
end

NokogiriPList::Generator.add(Time) do |generator, node, value|
  generator.create_child_element(node, "date", value.utc.strftime('%Y-%m-%dT%H:%M:%SZ'))
end

NokogiriPList::Generator.add(Date) do |generator, node, value| 
  generator.create_child_element(node, "date", value.strftime('%Y-%m-%dT%H:%M:%SZ')) # also catches DateTime
end

NokogiriPList::Generator.add(String, Symbol) do |generator, node, value| 
  generator.create_child_element(node, "string", value)
end

NokogiriPList::Generator.add(Fixnum, Bignum, Integer) do |generator, node, value| 
  generator.create_child_element(node, "integer", value)
end

NokogiriPList::Generator.add(Float) do |generator, node, value| 
  generator.create_child_element(node, "real", value)
end

NokogiriPList::Generator.add(BigDecimal) do |generator, node, value| 
  generator.create_child_element(node, "real", value.to_s('F'))
end
