module Nokogiri

  class << self

    def PList(xml)
      ::NokogiriPList::Parser.parse(XML(xml))
    end

  end

end
