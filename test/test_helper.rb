require File.join(File.dirname(__FILE__), '..', 'app_store')
require 'rubygems'
require 'shoulda'
require 'matchy'
require 'fakeweb'

FakeWeb.allow_net_connect = false

def fixture_file(id)
  File.read(File.expand_path(File.dirname(__FILE__)) + '/fixtures/' + id + '.plist')
end

def stub_app(id,price="0.99")
  data = fixture_file(id)
  data.gsub!(/<key>price<\/key><real>(.*)<\/real>/, "<key>price</key><real>#{price}</real>")
  FakeWeb.register_uri(:get, AppStore.app_url + "?id=#{id}", {:body => data})
end

def stub_search(term)
  data = fixture_file(term)
  FakeWeb.register_uri(:get, AppStore.search_url + "?media=software&term=#{term}", {:body => data})
end