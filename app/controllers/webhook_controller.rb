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
    
    if sProduct.images.blank?
      pImage = ""
    else 
      pImage = sProduct.images[0].attributes[:src]
    end 
    
    if product.blank?
      if not sProduct.blank?
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
     customer = Customer.where('email = ?', oCustomer[:email]).first
   
    
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
  


  

  
  # ------------------------------------------
  #          webhooks/rental/get_days
  # 
  # ------------------------------------------
  def get_days
    
    if params['cDate'] && params['productID']
      cDate = params['cDate']
      productID = params['productID'].to_i
      
      rDate = Date.parse(cDate)
      
      @pickupDate = false
  
      @day_buffer = 1
      
      startTime = Date.new rDate.year, rDate.month
      startTime -= @day_buffer
      
      endTime = Date.new rDate.year, rDate.month, -1
      endTime += (@day_buffer + 60)
      
      rProduct = Product.find(update_product(productID))
      @rentals = Rental.where('pickupDate >= ? AND deliveryDate <= ? AND product_id = ?', startTime, endTime, rProduct['id'].to_i)
      
      @quantity = rProduct['quantity']
      @rangeDays = Date.all_days(startTime, endTime)
      
      
      # Check known booked days from other rentals first   
      bookedDays = @rangeDays.select do |day|
        returnDay = true
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       # 
        @day = day
        bookedRentals = @rentals.select {|rental| (rental.deliveryDate <= (@day + @day_buffer) && rental.pickupDate >= (@day - @day_buffer)) ? true : false }
  
        if bookedRentals.length >= @quantity
          returnDay = true       
        else
          returnDay = false
        end
        returnDay
      end
      
      # Do Manual Unavailable days
      manualDays = Unavailable.where('awayDate >= ? AND awayDate <= ?', startTime, endTime)
      # You need to subtract out these days at the end                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    # 
      # end
      pairData = {}
      
      goodDays = @rangeDays - bookedDays
      goodDays -= manualDays
      
      availDays = goodDays.select do |day|
        returnDay = true
        
        if(day.sunday?) then returnDay = false end
        
        thirtydays_later = Date.new day.year, day.month, day.day
        thirtydays_later += 30
        
        m = Date.new day.year, day.month, day.day
        while m <= thirtydays_later && returnDay == true
          if(bookedDays.include? m)
            returnDay = false
          end 
          m += 1
        end
        
        
        if(returnDay == true)
          returnDay = false
          n = Date.new thirtydays_later.year, thirtydays_later.month, thirtydays_later.day
          while n <= (thirtydays_later + 10) && returnDay == false
            if ((!bookedDays.include? n) && (!manualDays.include? n) && !n.sunday?)
              returnDay = true
              pairData["#{day}"] = n
            end
            n += 1
          end
        end
        
        returnDay
      end
      
      unavailDays = @rangeDays - availDays
      
      returnData = {:unavailable => unavailDays, :available => availDays, :pairs => pairData}
      
      render :json => returnData.to_json, :callback => params[:callback]
    else
      render :json => {:error => "Missing Params"}
    end
    
    
  end
  
  def test
    @order = ShopifyAPI::Order.find(134626798)
    
    @date_info = {}
    @note_attributes = @order.note_attributes
    @note_attributes.each do |attribute|
      @date_info[attribute.attributes['name']] = attribute.attributes['value']
    end
    @id_product = 95938084
    delDate = @date_info["date_delivery-#{@id_product}"]
          puts "delDate: #{delDate}"
          pickDate = @date_info["date_pickup-#{@id_product}"]
          puts "pickDate: #{pickDate}"
    head :ok
  end
  
  # ------------------------------------------
  #          webhooks/orders/create
  # 
  # ------------------------------------------
  def order_created
    puts "Start: Order Created"
    data = ActiveSupport::JSON.decode(request.body.read)
    # puts data.inspect
    # render :json => data
    
    @order = ShopifyAPI::Order.find(data['id'])
    
    @date_info = {}
    @note_attributes = @order.note_attributes
    @note_attributes.each do |attribute|
      @date_info[attribute.attributes['name']] = attribute.attributes['value']
    end
    
    @id_customer = update_customer({:email => @order.attributes[:customer].attributes['email'], :first_name => @order.attributes[:customer].attributes['first_name'], :last_name => @order.attributes[:customer].attributes['last_name'], :customerID => @order.attributes[:customer].attributes['id'], :note => @order.attributes[:customer].attributes['note'], :phone => data['billing_address']['phone']})
    @id_location = update_locations(@order.attributes[:customer].attributes['id'], data['shipping_address'])
   
    products = data["line_items"]

    if products
      products.each do |product|
          puts "Each Product"
          @id_product = update_product(product['product_id'])
          # date_query = @note_attributes.select {|f| f.name == 'date_delivery-#{product["id"]}' }
          puts "date_info: #{@date_info.inspect}"
          puts "STRING:"
          puts "date_delivery-#{@id_product.to_i}"
          puts @date_info["date_delivery-#{@id_product}"]
           puts @date_info["date_delivery-#{@id_product}"].to_s
          
          @delDate = @date_info["date_delivery-#{@id_product.to_i}"]
          puts "@delDate: #{@delDate}"
          @pickDate = @date_info["date_pickup-#{@id_product}"]
          puts "@pickDate: #{@pickDate}"
          Rental.create(:product_id => @id_product, :location_id => @id_location, :customer_id => @id_customer, :orderID => data['id'], :deliveryDate => @delDate,:pickupDate => @pickDate)
      end
    end 
    
    
    head :ok


  end
  
  
  # ------------------------------------------
  #          webhooks/products/create
  # 
  # ------------------------------------------
  def product_created
    data = ActiveSupport::JSON.decode(request.body.read)
    update_product(data['id'])
    
    head :ok
  end
  
  
   # ------------------------------------------
  #          webhooks/orders/cancelled
  # 
  # ------------------------------------------
  def order_cancelled
    data = ActiveSupport::JSON.decode(request.body.read)
    
    Rental.delete_all(['orderID = ?', data['id']])
    
    head :ok
  end
  
  
  
   
  # ------------------------------------------
  #          webhooks/rentals_json
  # 
  # ------------------------------------------
  def rentals_json
    @params = params
    
    if not @params[:start] && @params[:end]
       render :text=>"Error: Missing Start/End Time for Calendar"
    else
      startTime = Time.new
      startTime = Time.at(@params[:start].to_i).strftime("%Y-%m-%d")
      
      endTime = Time.new
      endTime = Time.at(@params[:end].to_i).strftime("%Y-%m-%d")
      
      @rentals = Rental.where('(pickupDate >= ? AND pickupDate <= ?) OR (deliveryDate >= ? AND deliveryDate <= ?)', startTime, endTime, startTime, endTime)
      
      eventsArray = Array.new
      daysArray = Array.new
      @rentals.each do |rental|
        if(rental['rental_type'] == 'recurring')
          daysArray << {:title => '', :customer => rental['customer_id'], :start => rental['deliveryDate'], :className => ['recurring', 't_recurring'], :allDay => true, :backgroundColor => '#8AC8E6'}
          daysArray << {:title => '', :customer => rental['customer_id'], :start => rental['pickupDate'], :className => ['recurring', 't_pickup'],  :allDay => true, :backgroundColor => '#9AE88E'} 
        else
          daysArray << {:title => '', :customer => rental['customer_id'], :start => rental['deliveryDate'], :className => ['t_delivery'], :allDay => true, :backgroundColor => '#8AC8E6'}
          daysArray << {:title => '', :customer => rental['customer_id'], :start => rental['pickupDate'], :className => ['t_pickup'],  :allDay => true, :backgroundColor => '#9AE88E'} 
        end   
      end
     # render :text=>startTime
    
    daysArray.each do |day|
      eCount = 0
      search = eventsArray.select do |event|
        if((event[:start] == day[:start]) && (event[:customer] == day[:customer]))
          if (eventsArray[eCount][:className].include? day[:className][0])
          else
            eventsArray[eCount][:className] << day[:className][0]
            eventsArray[eCount][:backgroundColor] = '#EDF731'
          end
          true
        else
          false
        end
      end
      if search.length == 0
        eventsArray << day
      end
      eCount += 1
    end
    
    eventsArray.each do |event|
      customer = Customer.where('id = ?', event[:customer]).first
      event[:title] = "#{customer[:first_name]} #{customer[:last_name]}"
    end
      render :json => eventsArray.to_json
      

    end
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
# EXTEND DATE!
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