
class AdminController < ApplicationController
  around_filter :shopify_session
  
  def admin_rentals
    if not(params[:range_start] && params[:range_end])
      t = Date.today
      params[:range_start] = t
      params[:range_end] = t + 30
      @dates = Date.all_days(params[:range_start], params[:range_end])
    else
       @dates = Date.all_days(Date.parse(params[:range_start]), Date.parse(params[:range_end]))
    end
    
    if(params[:layout] == "customer")
      if not(params[:customerID])
        @error = "no customerID"
      end
      @customerID = params[:customerID]
      @rentals = Rental.where('(deliveryDate <= ? AND deliveryDate >= ? AND customer_id = ?) OR (pickupDate <= ? AND pickupDate >= ? AND customer_id = ?)', params[:range_end], params[:range_start], params[:customerID], params[:range_end], params[:range_start], params[:customerID])
    elsif(params[:layout] == "date")
      @rentals = Rental.where('(deliveryDate <= ? AND deliveryDate >= ?) OR (pickupDate <= ? AND pickupDate >= ?)', params[:range_end], params[:range_start], params[:range_end], params[:range_start])
    end
    @customers = Array.new
    @locations = Array.new
    
   
    @dates = @dates.select do |day|                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        # 
        @day = day
        eventDays = @rentals.select {|rental| (rental.deliveryDate == @day || rental.pickupDate == @day) ? true : false }
        if eventDays.length > 0
          returnDay = true
        else
          returnDay = false
        end
        returnDay
    end
    
    
    @rentals.map{|t| t.customer_id}.uniq.each do |id|
      @customers[id] = Customer.find(id)
    end
    
    @rentals.map{|t| t.location_id}.uniq.each do |id|
      @locations[id] = Location.find(id)
    end
    
    @params = params
    if(@error)
      render :text => @error
    else
      params[:layout] ? (render "rentals_#{params[:layout]}") : (render :text => "Error: Layout not present")
    end
 

  end



  def add_single_rental
    @customer = Customer.find(params[:customerID].to_i)
    @locations = Location.where('customer_id = ? AND location_type = ?', params[:customerID], 'single')
    
    render 'rentals_add_single'
  end
  
  def getAvailabilityAll
    products = Product.all
    @aProducts = []
    products.each do |product|
      if (getAvailability Date.parse(params[:startTime]), Date.parse(params[:endTime]), product[:id])  
        @aProducts << product
      end
    end
    
    render 'product_list', :layout => false
  end
  
  def getAvailability startTime, endTime, productID
    @pickupDate = false
  
    @day_buffer = 1
    
    rProduct = Product.find(productID.to_i)
    @rentals = Rental.where('pickupDate >= ? AND deliveryDate <= ? AND product_id = ?', startTime - @day_buffer, endTime + @day_buffer, rProduct['id'].to_i)
    puts "PRSD #{rProduct.inspect}"
    @quantity = rProduct['quantity']
    @rangeDays = Date.all_days(startTime, endTime)
    
    # Check known booked days from other rentals first   
    bookedDays = @rangeDays.select do |day|
      returnDay = true                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            # 
      @day = day
      bookedRentals = @rentals.select {|rental| (rental.deliveryDate <= (@day + @day_buffer) && rental.pickupDate >= (@day - @day_buffer)) ? true : false }
      
      puts "LENGTH: #{bookedRentals.length}"
      puts "QUANITYTY: #{@quantity}"
      
      if bookedRentals.length >= @quantity
        returnDay = true                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         # 
      else
        returnDay = false
      end
      returnDay
    end
    
    if(bookedDays.length > 0)
      false
    else
      true
    end 
  
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