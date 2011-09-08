String.class_eval do

  define_method :to_plist do
    Nokogiri::PList(self)
  end

end
