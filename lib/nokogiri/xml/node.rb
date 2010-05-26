module Nokogiri  
  
  module XML
    
    class Node
      
      def to_plist
        Nokogiri::PList.new.parse(self)
      end
      
    end

  end
  
end