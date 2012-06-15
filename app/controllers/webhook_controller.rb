class WebhookController < ApplicationController
  before_filter :init_session, :except => 'init_session'
  
  def init_session
    token = Token.where('id = ?', 1).first
    if token
      session = ShopifyAPI::Session.new("just-play-toy-rental.myshopify.com", token.code)
      ShopifyAPI::Base.activate_session(session) if session.valid?
    end
  end
    
  def update_product(oProduct)
   
    oProduct['product_id'] = 94091072
    
    product = Product.where('productID = ?', oProduct['product_id']).first
    sProduct = ShopifyAPI::Product.find(oProduct['product_id'])
    
  
    sProduct.title = "ANDREW"
    sProduct.save
    
    # if product
    #   product.handle = ""
    #   
    #   product = Product.new(:name => data["title"], :shopify_id => data["id"])
    #   product.save
    # end
  end
  
  def test
    # require 'rental.rb'
    # RentalMethods.init_session
  end
  
  def order_created
    data = ActiveSupport::JSON.decode(request.body.read)
    # puts data.inspect
    render :json => data
    
    products = data["line_items"]
    
    products.each do |product|
       update_product(product)
    end
    
     head :ok


    # product = Product.where('shopify_id = ?', data["id"]).first
    # if product
    #   event = WebhookEvent.new(:event_type => "product update")
    #   event.save
    #   product.name = data["title"]
    #   product.webhook_events << event
    #   product.save
    # end
    #   head :ok

  end
  
  def product_new
    data = ActiveSupport::JSON.decode(request.body.read)
    if Product.where('shopify_id = ?', data["id"]).first.exists?
      event = WebhookEvent.new(:event_type => "product new")
      event.save
      product = Product.new(:name => data["title"], :shopify_id => data["id"])
      product.webhook_events << event
      product.save
    end
      head :ok
  end

  def product_updated
    data = ActiveSupport::JSON.decode(request.body.read)
    puts "data = " + data.to_s
    product = Product.where('shopify_id = ?', data["id"]).first
    if product
      event = WebhookEvent.new(:event_type => "product update")
      event.save
      product.name = data["title"]
      product.webhook_events << event
      product.save
    end
      head :ok
  end

  def product_deleted
    data = ActiveSupport::JSON.decode(request.body.read)
    product = Product.where('shopify_id = ?', data["id"]).first
    if product
      puts 'products shop id: ' + product.shop.id
      event = WebhookEvent.new(:event_type => "product delete")
      event.save
      product.logical_delete = true
      product.webhook_events << event
      product.shop.webhook_events << event
      product.shop.save
      product.save
    end
    head :ok
  end
  
  private
  
  def verify_webhook 
    data = request.body.read.to_s
    hmac_header = request.headers['HTTP_X_SHOPIFY_HMAC_SHA256']
    puts '/n hmac_header='
    puts hmac_header
    digest = OpenSSL::Digest::Digest.new('sha256')
    calculated_hmac = Base64.encode64(OpenSSL::HMAC.digest(digest, ShopifyRental3::Application.config.shopify.secret, data)).strip
    puts '/n calculated_hmac='
    puts calculated_hmac
    unless calculated_hmac == hmac_header
      head :unauthorized
    end
    request.body.rewind
  end

end