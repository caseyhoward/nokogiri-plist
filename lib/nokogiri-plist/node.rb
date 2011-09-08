module NokogiriPList

  module Node

    def to_plist
      NokogiriPList::Parser.parse(self)
    end

  end

end
