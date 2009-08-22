require 'rubygems'
require 'mechanize'
require 'plist'

class StoreRequestError < StandardError; end

module AppStore
  extend self
  
  def app_url
    @app_url ||= 'http://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware'
  end
  
  def search_url
    @search_url ||= 'http://ax.search.itunes.apple.com/WebObjects/MZSearch.woa/wa/search'
  end
  
  
  # returns an App instance
  def fetch_app_by_id(id)
    page  = request(app_url,{:id => id})
    raise StoreRequestError unless page.code == "200"
    plist = Plist::parse_xml(page.body)
    return nil if plist["status-code"]
    app   = App.new(plist["item-metadata"])
  end
  
  # returns an array of first 24 App instances matching "term"
  def search(term)
    page = request(search_url, {:media => 'software', :term => term})
    raise StoreRequestError unless page.code == "200"
    plist = Plist::parse_xml(page.body)
    plist["items"].inject([]) { |arr,item| arr << App.new(item) unless item["type"] == "more"; arr }
  end
  
  private
  
  def request(url,params={})
    @agent ||= WWW::Mechanize.new { |a| a.user_agent = 'iTunes-iPhone/3.0' }
    # @agent.set_proxy('localhost',8080)
    @agent.get(:url => url, :headers => {"X-Apple-Store-Front" => '13441-1,2'}, :params => params)
  end
  
end

class App
  
  attr_reader :item_id, :title, :url, :icon_url, :price, :release_date
  
  def initialize(hash)
    @item_id      = hash["item-id"]
    @title        = hash["title"]
    @url          = hash["url"]
    @icon_url     = hash["artwork-urls"][0]["url"]
    @price        = hash["store-offers"]["STDQ"]["price"]
    @release_date = hash["release-date"]
  end
  
end