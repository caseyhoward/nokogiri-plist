String.class_eval do
  
  define_method :to_plist do
    Nokogiri::Parser::PList(self)
  end
  
  define_method :to_plist_xml do
    
  end
  
end