require 'test_helper'

class AppStoreTest < Test::Unit::TestCase
  
  context 'Fetching a single app' do
    setup do
      stub_app('282935706', '2.99')
      @app = AppStore.fetch_app_by_id('282935706')
    end
    
    should 'return an instance of App' do
      @app.class.should == App
    end
    
    should 'assign correct App attributes' do
      @app.title.should == "Bible"
      @app.url.should == "http://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=282935706&mt=8"
      @app.icon_url.should == "http://a1.phobos.apple.com/us/r30/Purple/fc/84/f2/mzl.bfusspir.png"
      @app.release_date.should == DateTime.new(2008,6,11,7,0,0)
      @app.price.should == 2.99
    end
  end
  
  context 'Searching for a list of apps' do
    setup do
      @term = 'bible'
      stub_search(@term)
      @results = AppStore.search(@term)
    end

    should 'return first 24 matches for search term' do
      @results.size.should == 24
    end
    
    should 'return an array of Apps' do
      @results.class.should == Array
      @results.first.class.should == App
    end
    
  end
end