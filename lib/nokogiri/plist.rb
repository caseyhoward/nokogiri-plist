module Nokogiri  
  
  class << self
    
    def PList(xml)
      Nokogiri::PList::Parser.new.parse(Nokogiri::XML(xml))
    end 
    
  end
  
end