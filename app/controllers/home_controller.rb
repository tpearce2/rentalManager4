class HomeController < ApplicationController
  
  around_filter :shopify_session, :except => 'welcome'
  
  def welcome
    current_host = "#{request.host}#{':' + request.port.to_s if request.port != 80}"
    @callback_url = "http://#{current_host}/login/finalize"
  end
  
  def stripe
    head :ok
  end
  
  def index
    #ShopifyAPI::Base.activate_session(session[:shopify])
    # get 5 products
   
    @products = ShopifyAPI::Product.find(:all, :params => {:limit => 10})
    
    

    # get latest 5 orders
   # ActiveResource::Base.site = "http://localhost"

    @orders = ShopifyAPI::Order.find(:all, :params => {:limit => 10})
  end
  
end