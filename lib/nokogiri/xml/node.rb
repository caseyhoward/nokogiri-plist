module Nokogiri  
  
  module XML
    
    class Node
      
      def to_plist
        Nokogiri::PList::Parser.parse(self)
      end
      
    end

  end
  
end