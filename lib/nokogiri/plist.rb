module Nokogiri  
  
  class << self
    
    def PList(xml)
      Nokogiri::PList::Parser.parse(Nokogiri::XML(xml))
    end 
    
  end
  
end