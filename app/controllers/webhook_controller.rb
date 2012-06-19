class WebhookController < ApplicationController
  before_filter :init_session, :except => 'init_session'
  
  def init_session
    token = Token.where('id = ?', 1).first
    if token
      session = ShopifyAPI::Session.new("just-play-toy-rental.myshopify.com", token.code)
      ShopifyAPI::Base.activate_session(session) if session.valid?
    end
  end
    
  
  
  # ------------------------------------------
  #           Update_product       
  # 
  # ------------------------------------------
  def update_product(oProductID)
   #Update products
     # oProductID = 94091072

    product = Product.where('productID = ?', oProductID).first
    sProduct =  ShopifyAPI::Product.find(oProductID)
    
    if product.blank?
      if not sProduct.blank?
        if sProduct.images.blank?
          pImage = ""
        else 
          pImage = sProduct.images[0].attributes[:src]
        end 
          
          newProduct = Product.new(:productID => sProduct.id, :title => sProduct.title, :body_html => sProduct.body_html, :tags => sProduct.tags, :productPrice => sProduct.variants[0].attributes[:price], :productSku => sProduct.variants[0].attributes[:sku], :productImage => pImage)
          newProduct.save
          return newProduct.id
      end
    # If product is not blank                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    # 
    else
      Product.update(product.id, {:productID => sProduct.id, :title => sProduct.title, :body_html => sProduct.body_html, :tags => sProduct.tags, :productPrice => sProduct.variants[0].attributes[:price], :productSku => sProduct.variants[0].attributes[:sku], :productImage => pImage})
      return product.id
    end

  end

  
  
  # ------------------------------------------
  #           Update_Customer        
  # 
  # ------------------------------------------
	def update_customer(oCustomer)
     customer = Customer.where('customerID = ?', oCustomer[:customerID]).first
   
    
    if customer.blank?
      newCustomer = Customer.new(oCustomer)  
      newCustomer.save 
      return newCustomer.id
    else
      customer.update_attributes(oCustomer)
      return customer.id
    end
  end
  
  
  # ------------------------------------------
  #           Update_Locations        
  # 
  # ------------------------------------------
  def update_locations(customerID, address)
    customer = Customer.where('customerID = ?', customerID).first
    locations = customer.locations.where('address1 = ? AND address2 = ?', address['address1'], address['address2']).first
    
    if locations.blank?
      newLoc = customer.locations.build(address)
      newLoc.save
      return newLoc.id
    else 
      return locations.id
    end
    
  end
  


  
  def test
    @badDates = Array.new
    
    @first_of_month = '2012-06-01'
    @end_of_month = '2012-06-30'
    @day_buffer = 3
    @quantity = 2
    
    startTime = Date.new
    startTime = Date.parse(@first_of_month)
    startTime -= @day_buffer
    
    endTime = Date.new
    endTime = Date.parse(@end_of_month)
    endTime += (@day_buffer + 60)
    
    @rentals = Rental.where('pickupDate >= ? AND deliveryDate <= ?', startTime, endTime)
    
    @rangeDays = Date.all_days(startTime, endTime)
    
    
    # Check known booked days from other rentals first   
    bookedDays = @rangeDays.select do |day|
      returnDay = true
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     # 
      @day = day
      bookedRentals = @rentals.select {|rental| (rental.deliveryDate <= @day && rental.pickupDate >= @day) ? true : false }

      if bookedRentals.length >= @quantity
        returnDay = true                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         # 
      else
        returnDay = false
      end
      returnDay
    end
    
    # Do Manual Unavailable days
    # You need to subtract out these days at the end                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    # 
    # end
    
    goodDays = @rangeDays - bookedDays
    
    unavailDays = goodDays.select do |day|
      returnDay = true
      
      thirtydays_later = Date.new day.year, day.month, day.day
      thirtydays_later += 30
      
      m = Date.new day.year, day.month, day.day
      while m <= thirtydays_later && returnDay == true
        if(bookedDays.include? m)
          returnDay = false
        end
        m += 1
      end
      
      returnDay
    end
    
    
    
    # newRentals = @rentals.select do |rental|
    #   if rental.id == 2
    #     false
    #   else
    #     true
    #   end
    #   
    # end
    
      
    # @day_buffer = 3
    # 
    #   startTime = Time.new
    #   startTime = Time.at(@params[:start].to_i).strftime("%Y-%m-%d")
    #   
    # @rentals = Rental.where('deliveryDate < ')
     # render :text => t.all_days(Date.parse(@first_of_month), Date.parse(@end_of_month))
     render :json => unavailDays
   
  end
  
  
  
  
  # ------------------------------------------
  #          webhooks/orders/create
  # 
  # ------------------------------------------
  def order_created
    data = ActiveSupport::JSON.decode(request.body.read)
    # puts data.inspect
    # render :json => data
    
    @order = ShopifyAPI::Order.find(data['id'])
    @note_attributes = @order.note_attributes
    
    @id_customer = update_customer({:email => @order.attributes[:customer].attributes['email'], :first_name => @order.attributes[:customer].attributes['first_name'], :last_name => @order.attributes[:customer].attributes['last_name'], :customerID => @order.attributes[:customer].attributes['id'], :note => @order.attributes[:customer].attributes['note'], :phone => data['billing_address']['phone']})
    @id_location = update_locations(@order.attributes[:customer].attributes['id'], data['shipping_address'])
   
    products = data["line_items"]

    if products
      products.each do |product|
          @id_product = update_product(product['product_id'])
          date_query = @attributes.select {|f| f.name == 'date_delivery-#{product["id"]}' }
          
          Rental.create(:product_id => @id_product, :location_id => @id_location, :customer_id => @id_customer, :orderID => data['id'])
      end
    end 
    
    
    head :ok


  end
  
  
  
  
   
  # ------------------------------------------
  #          webhooks/getPickupDate
  # 
  # ------------------------------------------
  def get_pickup_date
    
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

class Date
  def self.all_days from, to
      m = Date.new from.year, from.month, from.day
      result = []
      while m <= to
        result << m
        m += 1
      end
  
      result
    end
  end