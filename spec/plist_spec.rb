require 'lib/plist'

describe PList::Parser do

  describe ".parse" do
  
    before(:each) do
      @plist = PList::Parser.parse(File.join("spec", "files", "itunes.xml"))
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
    end

  end

end