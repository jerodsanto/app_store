A simple Ruby module to fetch app information from Apple's App Store.

Depends on [mechanize](http://mechanize.rubyforge.org/mechanize/)

    require 'app_store'

    # fetch a single App if you have the item-id
    my_app = AppStore.fetch_app_by_id('317468456')
    my_app.class
    => App
    my_app.title
    => "Stick It - iPhone Sticky Notes"
    my_app.price
    => 0.99
    my_app.methods - Object.methods
    => ["title", "url", "icon_url", "price", "release_date", "item_id"]
    
    # or fetch an array of apps matching a search term
    app_list = AppStore.search('notes')
    app_list.class
    => Array
    app_list.first.class
    => App