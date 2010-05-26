require 'nokogiri'
#require 'date'
#require 'lib/nokogiri/plist'
#require 'lib/nokogiri/xml/node'
#require 'lib/string'

describe 'plist' do

  describe ".parse" do
  
    before(:each) do
      @plist = Nokogiri::PList(open(File.join("spec", "files", "itunes.xml")))
    end

    it "parses correctly" do
      @plist['Major Version'].should == 1
      @plist['Minor Version'].should == 1
      @plist['Application Version'].should == '9.0.3'
      @plist['Features'].should == 5
      @plist['Show Content Ratings'].should == true
      @plist['Music Folder'].should == 'file://localhost/H:/Music/iTunes/iTunes%20Music/'
      @plist['Library Persistent ID'].should == 'E86929F823A6944A'
      @plist['Tracks'].size.should == 2
      @plist['Tracks']['123']['Name'].should == 'Lacquer Head' 
      @plist['Playlists'][0]['Name'].should == 'All'
      @plist['Playlists'][0]['Playlist Items'][0]['Track ID'].should == 123
      @plist['Playlists'][0]['Playlist Items'][1]['Track ID'].should == 124
    end

  end

end